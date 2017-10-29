# Module for fetching submissions from the PaperCall.io paper submission system
# Also providing some analytics
module Papercall
  attr_accessor :analysis
  METHOD_REGEX = /(.*)_talks$/

  def self.fetch(from, api_key='', *states)
    if from == :from_file
      @submissions = Papercall::FileFetcher.new('submissions.json')
    elsif from == :from_papercall
      @submissions = Papercall::RestFetcher.new(api_key)
    end
    @submissions.fetch(states)
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
    # TODO Move this logic to a separate analysis function
    # TODO Fetch reviews for each submission
    reviewers = {}
    all.each do |submission|
      submission['ratings'].each do |rating|
        unless(reviewers.include?(rating['user']['name']))
          reviewers[rating['user']['name']] = [{:id => rating['submission_id']}]
        else
          reviewers[rating['user']['name']].push({:id => rating['submission_id']})
        end
      end
    end
    #@analysis['reviewers'] = reviewers
    reviewers
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
