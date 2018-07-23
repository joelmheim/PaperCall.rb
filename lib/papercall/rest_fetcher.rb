require 'json'
require 'rest-client'
require 'parallel'

module Papercall
  # Fetches submissions from Papercall REST API
  # Params:
  class RestFetcher < Fetcher
    SUBMISSIONS_URL = 'https://www.papercall.io/api/v1/submissions'.freeze

    def initialize(api_key)
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
        JSON.parse raw_results
      else
        []
      end
    end

    def fetch(*states)
      states = [%i[submitted accepted rejected waitlist declined]] if states == [[:all]]
      states.flatten.each do |state|
        next unless state
        start_time = Time.now
        print "Fetching #{state} submissions from PaperCall API..."
        instance_variable_set("@#{state}", papercall(submission_url(state.to_s)))
        puts "finished in #{Time.now - start_time} seconds."
      end
      fetch_ratings
      fetch_feedback
    end

    def fetch_ratings
      start_time = Time.now
      print 'Fetching ratings for all submissions from Papercall API...'

      Parallel.each(analysis, in_threads: 8) do |submission|
        unless submission['ratings']
          ratings_url = "#{SUBMISSIONS_URL}/#{submission['id']}/ratings"
          submission['ratings'] = papercall(ratings_url)
        end
        submission['ratings'] = [] unless submission['ratings']
      end
      puts "finished in #{Time.now - start_time} seconds."
    end

    def fetch_feedback
      start_time = Time.now
      print 'Fetching feedback for all submissions from Papercall API...'
      Parallel.each(analysis, in_threads: 8) do |submission|
        unless submission['feedback']
          feedback_url = "#{SUBMISSIONS_URL}/#{submission['id']}/feedback"
          submission['feedback'] = papercall(feedback_url)
        end
        submission['feedback'] = [] unless submission['feedback']
      end
      puts "finished in #{Time.now - start_time} seconds."
    end
  end
end
