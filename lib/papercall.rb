require 'papercall/version'
require 'papercall/config'
require 'json'
require 'rest-client'

# Module for fetching submissions from the PaperCall.io paper submission system
# Also providing some analytics
module Papercall

  def self.fetch(from, *states)
    if from == :from_file
      @submissions = Papercall::FileFetcher.new('submissions.json')
    elsif from == :from_papercall
      @submissions = Papercall::RestFetcher.new
    end
    @submissions.fetch(states)
  end

  def self.submitted
    @submissions.submitted
  end

  def self.accepted
    @submissions.accepted
  end

  def self.rejected
    @submissions.rejected
  end

  def self.waitlist
    @submissions.waitlist
  end

  def self.all
    all = @submissions.submitted
    all += @submissions.accepted
    all += @submissions.rejected
    all += @submissions.waitlist
    all
  end

  def self.save_to_file(filename)
    ff = File.open(filename, 'w') {|f| f.write(all.to_json)}
    puts "All submissions written to file #{filename}." if ff
  end

  def self.number_of_submissions
    all.length
  end

  def self.confirmed_talks
    accepted.select do |s|
      s["confirmed"] == true
    end
  end


  class Fetcher
    attr_reader :submitted, :accepted, :rejected, :waitlist
  end

  class FileFetcher < Fetcher
    def initialize(filename)
      @filename = filename
    end

    def fetch(ignored)
      file = File.new(@filename, 'r')
      puts "Reading from file (#{file.path})..."
      submissions = JSON.parse file.read if file
      @submitted = submissions["submitted"]
      @accepted = submissions["accepted"]
      @rejected = submissions["rejected"]
      @waitlist = submissions["waitlist"]
    end
  end

  class RestFetcher < Fetcher

    SUBMISSIONS_URL = 'https://www.papercall.io/api/v1/submissions'
    AUTH_HASH = {Authorization: Papercall::Config::API_KEY}

    def initialize()
      @submitted = []
      @accepted = []
      @rejected = []
      @waitlist = []
    end

    def submission_url(state, per_page: 50)
      "#{SUBMISSIONS_URL}?state=#{state}&per_page=#{per_page}"
    end

    def papercall(state)
      raw_submissions = RestClient::Request.execute({:method => :get, :url => submission_url(state), :headers => AUTH_HASH}) # :timeout => 120
      JSON.parse raw_submissions
    end

    def fetch(*states)
      puts "States is #{states.flatten}"
      states.flatten.each do |state|
        if state
          puts "Fetching #{state} submissions from PaperCall API..."
          instance_variable_set("@#{state.to_s}", papercall(state.to_s))
        end
      end
      #@analysis['submissions'].each do |submission|
      #  base_url = "#{submissions_url}/#{submission["id"]}"
      #  ratings_url = "#{base_url}/ratings"
      #  ratings_json = RestClient::Request.execute({:method => :get, :url => ratings_url, :headers => auth_hash, :timeout => 120})
      #  submission["ratings"] = JSON.parse ratings_json
      #  feedback_url = "#{base_url}/feedback"
      #  feedback_json = RestClient::Request.execute(:method => :get, :url => feedback_url, :headers => auth_hash, :timeout => 120)
      #  submission["feedback"] = JSON.parse(feedback_json)
      #end
    end
  end

end
