module Papercall
  class Configuration
    attr_accessor :API_KEY, :input_file, :threads, :output

    def initialize
      @input_file = 'submissions.json'
      @threads = 150
      @output = true
    end
  end
end