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
    @analysis = Papercall::Analysis.new(@submissions.analysis)
    @analysis = @analysis.analyze
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
      s['confirmed'] == true
    end
  end

  def self.active_reviewers
    @analysis['reviewers']
  end

  def self.submissions_without_feedback
    @analysis['talksWithoutFeedback']
  end

  def self.submissions_with_enough_reviews
    @analysis['talksWithLessThanThreeReviews']
  end

  def self.analysis
    @analysis
  end

  def self.summary
    s = @analysis['summary']
    if configuration.output
      puts "Number of submissions: #{s['numSubmissions']}"
      puts "Number of active reviewers: #{s['numActiveReviewers']}"
      puts "Number of submitted talks without feedback: #{s['numWithoutFeedback']}"
      puts "Number of talks with three or more reviews: #{s['numCompleted']}"
      puts "Number of highly rated talks: #{s['numHighlyRated']}"
      puts "Number of low rated talks: #{s['numLowRated']}"
      puts "Number of middle rated talks: #{s['numMaybe']}"
      puts "Number of talks with less than three reviews: #{s['numLessThanThreeReviews']}"
      puts "Number of talks with four or more reviews: #{s['numWithFourOrMoreReviews']}"
      puts "Number of talks without reviews: #{s['numWithoutReviews']}"
      puts "Number of accepted talks: #{s['numAccepted']}"
      puts "Number of waitlisted talks: #{s['numWaitlisted']}"
      puts "Number of rejected talks: #{s['numRejected']}"
      puts "Number of confirmed talks: #{s['numConfirmed']}"
    end
    s
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
