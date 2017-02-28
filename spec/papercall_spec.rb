require "spec_helper"

describe Papercall do
  describe Papercall, "#fetch" do
    it "has a version number" do
      expect(Papercall::VERSION).not_to be nil
    end

    it "should read submissions from file" do
      Papercall::fetch(:from_file)
      expect(Papercall::submitted.length).to be > 0
      expect(Papercall::accepted.length).to be > 0
    end

    it "should fetch submitted from papercall" do
      Papercall::fetch(:from_papercall, :submitted)
      expect(Papercall::submitted.length).to be > 0
      expect(Papercall::accepted.length).to be 0
      expect(Papercall::rejected.length).to be 0
      expect(Papercall::waitlist.length).to be 0
    end

    it "should fetch accepted from papercall" do
      Papercall::fetch(:from_papercall, :accepted)
      expect(Papercall::accepted.length).to be > 0
      expect(Papercall::submitted.length).to be 0
      expect(Papercall::rejected.length).to be 0
      expect(Papercall::waitlist.length).to be 0
    end

    it "should fetch rejected from papercall" do
      Papercall::fetch(:from_papercall, :rejected)
      expect(Papercall::submitted.length).to be 0
      expect(Papercall::accepted.length).to be 0
      expect(Papercall::rejected.length).to be > 0
      expect(Papercall::waitlist.length).to be 0
    end

    it "should fetch waitlist from papercall" do
      Papercall::fetch(:from_papercall, :waitlist)
      expect(Papercall::submitted.length).to be 0
      expect(Papercall::accepted.length).to be 0
      expect(Papercall::rejected.length).to be 0
      expect(Papercall::waitlist.length).to be > 0
    end

  end

  describe Papercall, "#all_submissions" do
    before(:context) do
      Papercall::fetch(:from_papercall, :submitted, :accepted, :rejected, :waitlist)
    end

    it "should fetch all submissions from papercall" do
      expect(Papercall::submitted.length).to be 2
      expect(Papercall::accepted.length).to be 49
      expect(Papercall::rejected.length).to be 45
      expect(Papercall::waitlist.length).to be 12
    end

    it "should save submissions to file" do
      filename = 'test_write.json'
      Papercall::save_to_file(filename)
      expect(File).to exist(filename)
    end

    it "should be able to tell the total number of submissions" do
      expect(Papercall::number_of_submissions).to be 108
    end

    it "should list number of confirmed talks" do
      expect(Papercall::confirmed_talks.length).to be 43
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
