require 'spec_helper'
require 'papercall'

describe Papercall do
  describe Papercall, '#version_and_config' do
    it 'has a version number' do
      expect(Papercall::VERSION).not_to be nil
    end

    it 'should return an error when no API_KEY is configured' do
      expect{Papercall.fetch(:from_papercall)}.to raise_error(ArgumentError)
    end

    it 'accepts API_KEY as configuration' do
      Papercall.configure do |config|
        config.API_KEY = '123abcGiveMeAccess'
      end
      expect(Papercall.configuration.API_KEY).to eq '123abcGiveMeAccess'
    end

    it 'has default input_file config value' do
      expect(Papercall.configuration.input_file).to eq 'submissions.json'
    end

    it 'has default configuration for number of threads' do
      expect(Papercall.configuration.threads).to be 150
    end

    it 'has default configuration for displaying output' do
      expect(Papercall.configuration.output).to be true
    end
  end

  describe Papercall, '#fetch' do
    before(:context) do
      Papercall.configure do |config|
        config.API_KEY = ENV['PAPERCALL_TEST_KEY']
        config.output = false
      end
    end

    it 'should read submissions from file' do
      Papercall.fetch(:from_file)
      expect(Papercall.submitted_talks.length).to be > 0
      expect(Papercall.accepted_talks.length).to be > 0
      expect(Papercall.rejected_talks.length).to be > 0
      expect(Papercall.waitlist_talks.length).to be > 0
    end

    it 'should fetch submitted from papercall' do
      Papercall.fetch(:from_papercall, :submitted)
      expect(Papercall.submitted_talks.length).to be 2
    end

    it 'should fetch accepted from papercall' do
      Papercall.fetch(:from_papercall, :accepted)
      expect(Papercall.accepted_talks.length).to be > 0
      expect(Papercall.accepted_talks.first.ratings.length).to be > 0
    end

    it 'should fetch rejected from papercall' do
      Papercall.fetch(:from_papercall, :rejected)
      expect(Papercall.rejected_talks.length).to be > 0
    end

    it 'should fetch waitlist from papercall' do
      Papercall.fetch(:from_papercall, :waitlist)
      expect(Papercall.waitlist_talks.length).to be > 0
    end

    it 'should fetch declined from papercall' do
      Papercall.fetch(:from_papercall, :declined)
      expect(Papercall.declined_talks.length).to be > 0
    end

    it 'should fetch multiple states from papercall' do
      Papercall.fetch(:from_papercall, :submissions, :accepted)
    end
  end

  describe Papercall, '#all_submissions' do
    before(:context) do
      Papercall.configure do |config|
        config.API_KEY = ENV['PAPERCALL_TEST_KEY']
        config.output = false
      end
      Papercall.fetch(:from_papercall, :all)
    end

    it 'should fetch all submissions from papercall' do
      expect(Papercall.submitted_talks.length).to be 2
      expect(Papercall.accepted_talks.length).to be 52
      expect(Papercall.rejected_talks.length).to be 43
      expect(Papercall.waitlist_talks.length).to be 9
      expect(Papercall.declined_talks.length).to be 3
    end

    it 'should save submissions to file' do
      filename = 'test_write.json'
      puts Papercall.all
      #Papercall.save_to_file(filename)
      #expect(File).to exist(filename)
    end
  end

  describe Papercall, '#analysis' do
    before(:context) do
      Papercall.configure do |config|
        config.API_KEY = ENV['PAPERCALL_TEST_KEY']
        config.output = false
      end
      Papercall.fetch(:from_papercall, :all)
    end

    it 'should be able to tell the total number of submissions' do
      expect(Papercall.number_of_submissions).to be 109
    end

    it 'should list number of confirmed talks' do
      expect(Papercall.confirmed_talks.length).to be 49
    end

    it 'should list all active reviewers' do
      expect(Papercall.active_reviewers.length).to be 21
    end

    it 'should list submissions without feedback' do
      expect(Papercall.submissions_without_feedback.length).to be 1
    end

    it 'should list submissions with enough reviews' do
      expect(Papercall.submissions_with_enough_reviews.length).to be 2
    end

    it 'should have a summary method' do
      expect(Papercall.summary).not_to be nil
    end

    it 'should expose all analysis results' do
      expect(Papercall.analysis).to be_an Object
    end
  end

  #
  # Features:
  # Fetch from papercall - feedback
  # Fetch from papercall - reviews
  # Analyze
  #   number of active reviewer
  #   number of submissions missing feedback
  #   number of submissions with enough reviews
  #   number of highly rated talks (at least three reviews)
  #   number of low rated talks (at least three reviews)
  #   number of maybes (at least three reviews)
  #   number of submissions with less than three reviews
  #   number of submissions missing reviews
  #   number of submissions with four or more reviews
  #   number of confirmed talks
end
