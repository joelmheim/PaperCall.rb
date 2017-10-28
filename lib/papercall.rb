require 'papercall/version'
require 'papercall/config'
require 'json'
require 'rest-client'

# Module for fetching submissions from the PaperCall.io paper submission system
# Also providing some analytics
module Papercall
  attr_accessor :analysis
  METHOD_REGEX = /(.*)_talks$/

  def self.fetch(from, api_key='', *states)
    if from == :from_file
      @submissions = Papercall::FileFetcher.new('submissions.json')
    elsif from == :from_papercall
      @submissions = Papercall::RestFetcher.new(api_key)
    end
    @submissions.fetch(states)
  end

  def self.all
    @submissions.analysis
  end

  def self.save_to_file(filename)
    ff = File.open(filename, 'w') { |f| f.write(@submissions.all.to_json) }
    puts "All submissions written to file #{filename}." if ff
  end

  def self.number_of_submissions
    all.length
  end

  def self.confirmed_talks
    @submissions.accepted.select do |s|
      s['confirmed'] == true
    end
  end

  def self.active_reviewers
    # TODO Move this logic to a separate analysis function
    # TODO Fetch reviews for each submission
    reviewers = []
    all.each do |submission|
      submission['ratings'].each do |rating|
        unless(reviewers.include?(rating['user']['name']))
          reviewers[rating['user']['name']] = [{:id => rating['submission_id']}]
        else
          reviewers[rating['user']['name']].push({:id => rating['submission_id']})
        end
      end
    end
  end

  def self.respond_to_missing?(method_name, _include_private = false)
    METHOD_REGEX.match method_name.to_s
  end

  def self.method_missing(method_name, *args, &block)
    if METHOD_REGEX.match method_name.to_s
      @submissions.send(Regexp.last_match[1])
    else
      super
    end
  end

  # Superclass for fetchers. A fetcher fetches submissions of different
  # categories and stores them in instance variables.
  class Fetcher
    attr_reader :submitted, :accepted, :rejected, :waitlist, :declined

    def all
      {
        submitted: @submitted,
        accepted: @accepted,
        rejected: @rejected,
        waitlist: @waitlist,
        declined: @declined
      }
    end

    def analysis
      all = @submitted
      all += @accepted
      all += @rejected
      all += @waitlist
      all += @declined
      all
    end
  end

  # Fetches submissions from file.
  # Params:
  # +filename+:: File with submissions. JSON format.
  class FileFetcher < Fetcher
    def initialize(filename)
      @filename = filename
      @submitted = []
      @accepted = []
      @rejected = []
      @waitlist = []
      @declined = []
    end

    def fetch(_)
      file = File.new(@filename, 'r')
      puts "Reading from file (#{file.path})..."
      submissions = JSON.parse file.read if file
      @submitted = submissions['submitted']
      @accepted = submissions['accepted']
      @rejected = submissions['rejected']
      @waitlist = submissions['waitlist']
    end
  end

  # Fetches submissions from Papercall REST API
  # Params:
  class RestFetcher < Fetcher
    SUBMISSIONS_URL = 'https://www.papercall.io/api/v1/submissions'.freeze
    #AUTH_HASH = { Authorization: @api_key }.freeze

    def initialize(api_key)
      @auth_hash = { Authorization: api_key }
      @submitted = []
      @accepted = []
      @rejected = []
      @waitlist = []
      @declined = []
    end

    def submission_url(state, per_page: 50)
      "#{SUBMISSIONS_URL}?state=#{state}&per_page=#{per_page}"
    end

    def papercall(papercall_url)
      raw_results =
        RestClient::Request.execute(method: :get,
                                    url: papercall_url,
                                    headers: @auth_hash) # :timeout => 120
      JSON.parse raw_results
    end

    def fetch(*states)
      states.flatten.each do |state|
        if state
          puts "Fetching #{state} submissions from PaperCall API..."
          instance_variable_set("@#{state}", papercall(submission_url(state.to_s)))
        end
      end
      fetch_ratings
    end

    def fetch_ratings
      analysis.each do |submission|
        unless submission['ratings']
          ratings_url = "#{SUBMISSIONS_URL}/#{submission['id']}/ratings"
          submission["ratings"] = papercall(ratings_url)
        end
      end
    end

  end
end
