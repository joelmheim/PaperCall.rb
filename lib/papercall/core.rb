# Module for fetching submissions from the PaperCall.io paper submission system
# Also providing some analytics
module Papercall
  METHOD_REGEX = /(.*)_talks$/
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.fetch(from, *states)
    if from == :from_file
      @submissions = Papercall::FileFetcher.new
    elsif from == :from_papercall
      @submissions = Papercall::RestFetcher.new
    end
    @submissions.fetch(states)
    #puts @submissions.analysis
    @analysis = Papercall::Analysis.new(@submissions.analysis)
  end

  def self.all
    @submissions.analysis
  end

  def self.save_to_file(filename)
    ff = File.open(filename, 'w') { |f| f.write(@submissions.all.to_json) }
    puts "All submissions written to file #{filename}." if ff && configuration.output
  end

  def self.number_of_submissions
    all.length
  end

  def self.confirmed_talks
    @submissions.accepted.select do |s|
      s.confirmed?
    end
  end

  def self.active_reviewers
    @analysis.reviewers
  end

  def self.submissions_without_feedback
    @analysis.talks_without_feedback
  end

  def self.submissions_with_enough_reviews
    @analysis.submissions - @analysis.talks_missing_reviews
  end

  def self.analysis
    @analysis
  end

  def self.summary
    a = @analysis
    if configuration.output
      puts "Number of submissions: #{a.number_of_submissions}"
      puts "Number of active reviewers: #{a.number_of_active_reviewers}"
      puts "Number of submitted talks without feedback: #{a.number_without_feedback}"
      puts "Number of talks with three or more reviews: #{a.number_completed}"
      puts "Number of highly rated talks: #{a.number_of_highly_rated}"
      puts "Number of low rated talks: #{a.number_of_low_rated}"
      puts "Number of middle rated talks: #{a.number_of_maybes}"
      puts "Number of talks with less than three reviews: #{a.number_with_few_reviews}"
      puts "Number of talks with four or more reviews: #{a.number_with_many_reviews}"
      puts "Number of talks without reviews: #{a.number_without_reviews}"
      puts "Number of accepted talks: #{a.number_accepted}"
      puts "Number of waitlisted talks: #{a.number_of_waitlisted}"
      puts "Number of rejected talks: #{a.number_rejected}"
      puts "Number of confirmed talks: #{a.number_confirmed}"
    end
    a
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
end
