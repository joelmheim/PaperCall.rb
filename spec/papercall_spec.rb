require 'spec_helper'
require 'papercall'

describe Papercall do
  describe Papercall, '#fetch' do
    it 'has a version number' do
      expect(Papercall::VERSION).not_to be nil
    end

    it 'should read submissions from file' do
      Papercall.fetch(:from_file)
      expect(Papercall.submitted_talks.length).to be > 0
      expect(Papercall.accepted_talks.length).to be > 0
      expect(Papercall.rejected_talks.length).to be > 0
      expect(Papercall.waitlist_talks.length).to be > 0
    end

    it 'should fetch submitted from papercall' do
      Papercall.fetch(:from_papercall, '7460df7e664ca9511fc3c698381e0115', :submitted)
      # CFP is closed no more regular submissions
      expect(Papercall.submitted_talks.length).to be 0
    end

    it 'should fetch accepted from papercall' do
      Papercall.fetch(:from_papercall, '7460df7e664ca9511fc3c698381e0115', :accepted)
      expect(Papercall.accepted_talks.length).to be > 0
    end

    it 'should fetch rejected from papercall' do
      Papercall.fetch(:from_papercall, '7460df7e664ca9511fc3c698381e0115', :rejected)
      expect(Papercall.rejected_talks.length).to be > 0
    end

    it 'should fetch waitlist from papercall' do
      Papercall.fetch(:from_papercall, '7460df7e664ca9511fc3c698381e0115', :waitlist)
      expect(Papercall.waitlist_talks.length).to be > 0
    end

    it 'should fetch declined from papercall' do
      Papercall.fetch(:from_papercall, '7460df7e664ca9511fc3c698381e0115', :declined)
      expect(Papercall.declined_talks.length).to be > 0
    end

    it 'should fetch multiple states from papercall' do
      Papercall.fetch(:from_papercall, '7460df7e664ca9511fc3c698381e0115', :submissions, :accepted)
    end
  end

  describe Papercall, '#all_submissions' do
    before(:context) do
      Papercall.fetch(:from_papercall, '7460df7e664ca9511fc3c698381e0115', :all)
    end

    it 'should fetch all submissions from papercall' do
      expect(Papercall.submitted_talks.length).to be 0
      expect(Papercall.accepted_talks.length).to be 50
      expect(Papercall.rejected_talks.length).to be 45
      expect(Papercall.waitlist_talks.length).to be 9
      expect(Papercall.declined_talks.length).to be 3
    end

    it 'should save submissions to file' do
      filename = 'test_write.json'
      Papercall.save_to_file(filename)
      expect(File).to exist(filename)
    end

    it 'should be able to tell the total number of submissions' do
      expect(Papercall.number_of_submissions).to be 107
    end

    it 'should list number of confirmed talks' do
      expect(Papercall.confirmed_talks.length).to be 47
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
