require 'json'
require 'rest-client'
require 'parallel'
require 'active_support/core_ext/hash/indifferent_access'
require 'papercall/models/submission'
require 'papercall/models/rating'
require 'papercall/models/feedback'

module Papercall
  # Fetches submissions from Papercall REST API
  # Params:
  class RestFetcher < Fetcher
    SUBMISSIONS_URL = 'https://www.papercall.io/api/v1/submissions'.freeze

    def initialize()
      @output = Papercall.configuration.output
      api_key = Papercall.configuration.API_KEY
      raise ArgumentError, 'Missing API_KEY for access to Papercall. Please refer to documentation for instructions on setting this value.' unless api_key
      @auth_hash = { Authorization: api_key }
      @submitted = []
      @accepted = []
      @rejected = []
      @waitlist = []
      @declined = []
    end

    def submission_url(state, per_page: 150)
      "#{SUBMISSIONS_URL}?state=#{state}&per_page=#{per_page}"
    end

    def papercall(papercall_url)
      raw_results =
        RestClient::Request.execute(method: :get,
                                    url: papercall_url,
                                    headers: @auth_hash) # :timeout => 120
      if raw_results
        JSON.parse(raw_results).map {|r| r.with_indifferent_access}
      else
        []
      end
    end

    def fetch(*states)
      states = [%i[submitted accepted rejected waitlist declined]] if states == [[:all]]
      states.flatten.each do |state|
        next unless state
        start_time = Time.now
        print "Fetching #{state} submissions from PaperCall API..." if @output
        submissions = papercall(submission_url(state.to_s))
        instance_variable_set("@#{state}_raw", submissions)
        instance_variable_set("@#{state}", submissions.map {|s| Submission.new(s)})
        puts "finished in #{Time.now - start_time} seconds." if @output
      end
      fetch_ratings
      fetch_feedback
    end

    def fetch_ratings
      start_time = Time.now
      print 'Fetching ratings for all submissions from Papercall API...' if @output

      Parallel.each(analysis, in_threads: 128) do |submission|
        if submission.ratings.empty?
          ratings_url = "#{SUBMISSIONS_URL}/#{submission.id}/ratings"
          ratings = papercall(ratings_url)
          submission.ratings = ratings
        end
        #submission.ratings = [] unless submission.ratings
      end
      puts "finished in #{Time.now - start_time} seconds." if @output
    end

    def fetch_feedback
      start_time = Time.now
      print 'Fetching feedback for all submissions from Papercall API...' if @output
      Parallel.each(analysis, in_threads:  128) do |submission|
        if submission.feedback.empty?
          feedback_url = "#{SUBMISSIONS_URL}/#{submission.id}/feedback"
          submission.feedback = papercall(feedback_url).map {|f| Feedback.new(f)}
        end
        #submission.feedback = [] unless submission.feedback
      end
      puts "finished in #{Time.now - start_time} seconds." if @output
    end
  end
end
