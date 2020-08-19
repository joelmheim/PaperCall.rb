require 'json'

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
      puts "Reading from file (#{file.path})..." if @output
      submissions = JSON.parse file.read if file
      @submitted = submissions['submitted']
      @accepted = submissions['accepted']
      @rejected = submissions['rejected']
      @waitlist = submissions['waitlist']
    end
  end
end
