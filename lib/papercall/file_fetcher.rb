require 'json'
require 'papercall/models/submission'
require 'active_support/core_ext/hash/indifferent_access'

module Papercall
  # Fetches submissions from file.
  # Params:
  # +filename+:: File with submissions. JSON format.
  class FileFetcher < Fetcher
    def initialize()
      @output = Papercall.configuration.output
      @filename = Papercall.configuration.input_file
      @submitted = []
      @accepted = []
      @rejected = []
      @waitlist = []
      @declined = []
    end

    def fetch(_)
      file = File.new(@filename, 'r')
      puts 'Reading from file (#{file.path})...' if @output
      submissions = JSON.parse(file.read).with_indifferent_access if file
      @submitted = submissions[:submitted].map {|s| Submission.new(s)}
      @accepted = submissions[:accepted].map {|s| Submission.new(s)}
      @rejected = submissions[:rejected].map {|s| Submission.new(s)}
      @waitlist = submissions[:waitlist].map {|s| Submission.new(s)}
    end
  end
end
