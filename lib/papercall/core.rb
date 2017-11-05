# Module for fetching submissions from the PaperCall.io paper submission system
# Also providing some analytics
module Papercall
  METHOD_REGEX = /(.*)_talks$/

  def self.fetch(from, api_key='', *states)
    if from == :from_file
      @submissions = Papercall::FileFetcher.new('submissions.json')
    elsif from == :from_papercall
      @submissions = Papercall::RestFetcher.new(api_key)
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
    @analysis['reviewers']
  end

  def self.submissions_without_feedback
    @analysis['talksWithoutFeedback']
  end

  def self.submissions_with_enough_reviews
    @analysis['talksWithLessThanThreeReviews']
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
