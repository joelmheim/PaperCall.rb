require 'json'
require 'rest-client'

module Papercall
  #Fetches submissions from Papercall REST API
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
      states = [[:submitted, :accepted, :rejected, :waitlist, :declined]] if states == [[:all]]
      states.flatten.each do |state|
        if state
          puts "Fetching #{state} submissions from PaperCall API..."
          instance_variable_set("@#{state}", papercall(submission_url(state.to_s)))
        end
      end
      fetch_ratings
      fetch_feedback
    end

    def fetch_ratings
      puts "Fetching ratings for all submissions from Papercall API..."
      analysis.each do |submission|
        unless submission['ratings']
          ratings_url = "#{SUBMISSIONS_URL}/#{submission['id']}/ratings"
          submission['ratings'] = papercall(ratings_url)
        end
      end
    end

    def fetch_feedback
      puts "Fetching feedback for all submissions from Papercall API..."
      analysis.each do |submission|
        unless submission['feedback']
          feedback_url = "#{SUBMISSIONS_URL}/#{submission['id']}/feedback"
          submission['feedback'] = papercall(feedback_url)
        end
      end
    end
  end
end
