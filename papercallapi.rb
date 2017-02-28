module PaperCallAPI

  require 'rest-client'
  require 'json'

  attr_accessor :analysis

  TESTFILE = './test.json'

  def status
    puts "Number of submissions: #{@analysis['summary']['numSubmissions']}"
    puts "Number of active reviewers: #{@analysis['summary']['numActiveReviewers']}"
    puts "Number of submissions missing feedback: #{@analysis['summary']['numWithoutFeedback']}"
    puts "Number of submissions with enough reviews:  #{@analysis['summary']['numCompleted']}"
    puts "Number of highly rated talks (at least three reviews): #{@analysis['summary']['numHighlyRated']}"
    puts "Number of low rated talks (at least three reviews): #{@analysis['summary']['numLowRated']}"
    puts "Number of maybes (at least three reviews): #{@analysis['summary']['numMaybe']}"
    puts "Number of submissions with less than three reviews: #{@analysis['summary']['numLessThanThreeReviews']}"
    puts "Number of submissions missing reviews: #{@analysis['summary']['numWithoutReviews']}"
    puts "Number of submissions with four or more reviews: #{@analysis['summary']['numWithFourOrMoreReviews']}"
    puts "Number of accepted submissions: #{@analysis['summary']['numAccepted']}"
    puts "Number of waitlisted submissions: #{@analysis['summary']['numWaitlisted']}"
    puts "Number of rejected submissions: #{@analysis['summary']['numRejected']}"
    puts "Number of confirmed talks: #{@analysis['summary']['numConfirmed']}"
  end

  def saveToFile
    timestamp = DateTime.now.strftime '%Y%m%d%H%M'
    filename = "pc_#{timestamp}.json"
    tf = File.open(filename, 'w') {|f| f.write(@analysis.to_json)}
    puts "Daily stats saved successfully (#{filename})!" if tf
  end

  def activeReviewers
    reviewers = @analysis['reviewers'].keys
    reviewers.each do |reviewer|
      puts "#{reviewer} (#{@analysis['reviewers'][reviewer].size})"
    end
  end

  def updateTestFile
    unless @analysis['submissions'].empty?
      tf = File.open(PaperCallAPI::TESTFILE, 'w') {|f| f.write(@analysis.to_json)}
      puts "Testfile successfully updated (#{PaperCallAPI::TESTFILE})!" if tf
    end
  end

  def clearlyAcceptedToCSV
    filename = "highlyRated.csv"
    hashes = @analysis['highlyRated']
    writeToFile(filename, to_csv(submissionsFromHash(hashes)), "#{hashes.size} talks exported to file #{filename}")
  end

  def clearlyRejectedToCSV
    filename = "lowRated.csv"
    hashes = @analysis['lowRated']
    writeToFile(filename, to_csv(submissionsFromHash(hashes)), "#{hashes.size} talks exported to file #{filename}")
  end

  def maybeToCSV
    filename = "maybe.csv"
    hashes = @analysis['maybe']
    writeToFile(filename, to_csv(submissionsFromHash(hashes)), "#{hashes.size} talks exported to file #{filename}")
  end

  def techtalkstextfile
    filename = "techtalks.txt"
    techtalks = []
    @analysis['submissions'].each do |submission|
      techtalks.push(submission) if (submission['talk']['talk_format'] == "Tech Talks and Tech Tutorials (30 or 90 minutes - please specify the exact time in the Notes section)")
    end
    writeToFile(filename, techtalkdetails(techtalks), "#{techtalks.size} tech talks written to file #{filename}")
  end

  def missingFeedback
    filename = "missing_feedback.csv"
    missingFeedback = []
    @analysis['submissions'].each do |submission|
      missingFeedback.push(submission) if (submission['feedback'].size <= 2)
    end
    writeToFile(filename, feedbackdetails(missingFeedback), "#{missingFeedback.size} talks with little or no feedback written to file #{filename}")
  end

  def listConfirmed
    confirmed = []
    @analysis['confirmed'].each do |submission|
      confirmed.push(submission[:id])
    end
    puts confirmed.sort
  end

  private

  def writeToFile(filename, content, message)
    ff = File.open(filename, 'w') {|f| f.write(content)}
    puts message if (ff && message)
  end

  def feedbackdetails(missingfb)
    output = "Id;Title;Rating;NumReviews;NumFeedback\n"
    missingfb.each do |talk|
      output += "#{id(talk)};#{title(talk)};#{rating(talk)};#{numReviews(talk)};#{numFeedback(talk)}\n"
    end
    output
  end

  def techtalkdetails(techtalks)
    output = ""
    techtalks.each do |submission|
      output += "#{id(submission)} - #{title(submission)} ()\n"
    end
    output
  end

  def fetch_submissions
    @analysis = {}
    @analysis['submissions'] = []
    if (@from_file)
      testf = File.new(PaperCallAPI::TESTFILE, 'r')
      Dir.glob("pc_*.json") do |filename|
        file = File.new(filename, 'r')
        testf = file if file.mtime > testf.mtime
      end
      puts "Reading from file (#{testf.path})..."
      if testf
        @analysis = JSON.parse testf.read
      end
      testf.close
    else
      puts "Fetching updated results from PaperCall API..."
      submissions_url = 'https://www.papercall.io/api/v1/submissions'
      auth_hash = {:Authorization => '7460df7e664ca9511fc3c698381e0115'}
      #response = RestClient.get(submissions_url + "?per_page=150", auth_hash)
      submitted = RestClient::Request.execute({:method => :get, :url => submissions_url + "?state=submitted&per_page=150", :headers => auth_hash, :timeout => 120})
      rejected = RestClient::Request.execute({:method => :get, :url => submissions_url + "?state=rejected&per_page=150", :headers => auth_hash, :timeout => 120})
      accepted = RestClient::Request.execute({:method => :get, :url => submissions_url + "?state=accepted&per_page=150", :headers => auth_hash, :timeout => 120})
      waitlist = RestClient::Request.execute({:method => :get, :url => submissions_url + "?state=waitlist&per_page=150", :headers => auth_hash, :timeout => 120})
      submissions = JSON.parse submitted
      submissions += JSON.parse rejected
      submissions += JSON.parse accepted
      submissions += JSON.parse waitlist
      @analysis['submissions'] = submissions

      @analysis['submissions'].each do |submission|
        base_url = "#{submissions_url}/#{submission["id"]}"
        ratings_url = "#{base_url}/ratings"
        ratings_json = RestClient::Request.execute({:method => :get, :url => ratings_url, :headers => auth_hash, :timeout => 120})
        submission["ratings"] = JSON.parse ratings_json
        feedback_url = "#{base_url}/feedback"
        feedback_json = RestClient::Request.execute(:method => :get, :url => feedback_url, :headers => auth_hash, :timeout => 120)
        submission["feedback"] = JSON.parse(feedback_json)
      end
    end
  end

  def analyze
    @analysis['reviewers'] = {}
    @analysis['talksWithoutReviews'] = []
    @analysis['talksWithLessThanThreeReviews'] = []
    @analysis['talksWithFourOrMoreReviews'] = []
    @analysis['talksWithoutFeedback'] = []
    @analysis['highlyRated'] = []
    @analysis['lowRated'] = []
    @analysis['maybe'] = []
    @analysis['accepted'] = []
    @analysis['waitlist'] = []
    @analysis['rejected'] = []
    @analysis['confirmed'] = []
    @analysis['submissions'].each do |submission|
      submission["ratings"].each do |rating|
        unless(@analysis['reviewers'].include?(rating["user"]["name"]))
          @analysis['reviewers'][rating["user"]["name"]] = [{:id => rating["submission_id"]}]
        else
          @analysis['reviewers'][rating['user']['name']].push({:id => rating["submission_id"]})
        end
      end
      @analysis['talksWithoutReviews'].push({:id => submission["id"]}) if submission["ratings"].empty?
      @analysis['talksWithFourOrMoreReviews'].push({:id => submission["id"]}) if submission["ratings"].size >= 4
      @analysis['talksWithLessThanThreeReviews'].push({:id => submission["id"]}) if submission["ratings"].size < 3
      @analysis['talksWithoutFeedback'].push({:id => submission["id"]}) if submission["feedback"].empty?
      @analysis['highlyRated'].push({:id => submission["id"], :submission => submission}) if highlyRated? submission
      @analysis['lowRated'].push({:id => submission["id"], :submission => submission}) if lowRated? submission
      @analysis['maybe'].push({:id => submission["id"], :submission => submission}) if maybe? submission
      @analysis['accepted'].push({:id => submission["id"], :submission => submission}) if accepted? submission
      @analysis['waitlist'].push({:id => submission["id"], :submission => submission}) if waitlisted? submission
      @analysis['rejected'].push({:id => submission["id"], :submission => submission}) if rejected? submission
      @analysis['confirmed'].push({:id => submission["id"], :submission => submission}) if confirmed? submission
    end
    @analysis['summary'] = summary
  end

  def highlyRated?(submission)
    submission["rating"] >= 75 && review_complete?(submission)
  end

  def lowRated?(submission)
    submission["rating"] <= 25 && review_complete?(submission)
  end

  def maybe?(submission)
    !accepted?(submission) && !rejected?(submission) && review_complete?(submission)
  end

  def review_complete?(submission)
    submission["ratings"].size >= 3
  end

  def accepted?(submission)
    submission["state"] == "accepted"
  end

  def rejected?(submission)
    submission["state"] == "rejected"
  end

  def waitlisted?(submission)
    submission["state"] == "waitlist"
  end

  def confirmed?(submission)
    accepted?(submission) && submission["confirmed"] == true
  end

  def summary
    summary = {}
    summary['numSubmissions'] = @analysis['submissions'].size
    summary['numActiveReviewers'] = @analysis['reviewers'].size
    summary['numWithoutFeedback'] = @analysis['talksWithoutFeedback'].size
    summary['numCompleted'] = @analysis['submissions'].size - @analysis['talksWithLessThanThreeReviews'].size
    summary['numHighlyRated'] = @analysis['highlyRated'].size
    summary['numLowRated'] = @analysis['lowRated'].size
    summary['numMaybe'] = @analysis['maybe'].size
    summary['numLessThanThreeReviews'] = @analysis['talksWithLessThanThreeReviews'].size
    summary['numWithFourOrMoreReviews'] = @analysis['talksWithFourOrMoreReviews'].size
    summary['numWithoutReviews'] = @analysis['talksWithoutReviews'].size
    summary['numAccepted'] = @analysis['accepted'].size
    summary['numWaitlisted'] = @analysis['waitlist'].size
    summary['numRejected'] = @analysis['rejected'].size
    summary['numConfirmed'] = @analysis['confirmed'].size
    summary
  end

  def csv_header
    "Id;Title;Session Type;Author;Rating;Trust;Review(#);Reviewers;Abstract\n"
  end

  def to_csv(submissions)
    csv_string = csv_header
    submissions.each do |submission|
      csv_string += to_csv_row(submission)
      csv_string += "\n"
    end
    csv_string
  end

  def to_csv_row(submission)
    "#{id(submission)};#{title(submission)};#{talkFormat(submission)};#{author(submission)};#{rating(submission)};#{trust(submission)};#{numReviews(submission)};#{reviewers(submission)};#{abstract(submission)}"
  end

  def id(submission)
    submission['id']
  end

  def title(submission)
    submission['talk']['title']
  end

  def talkFormat(submission)
    submission['talk']['talk_format']
  end

  def author(submission)
    submission['profile']['name']
  end

  def rating(submission)
    submission['rating']
  end

  def trust(submission)
    submission['trust']
  end

  def numReviews(submission)
    submission['ratings'].size
  end

  def numFeedback(submission)
    submission['feedback'].size
  end

  def reviewers(submission)
    reviewers = ""
    submission['ratings'].each do |rating|
      reviewers += rating['user']['name']
      reviewers += ", "
    end
    reviewers[0..-3]
  end

  def abstract(submission)
    submission['talk']['abstract'].gsub("\n", " ")
  end

  def submissionsFromHash(submissionshashes)
    submissionshashes.map { |s| s[:submission] }
  end
end

class PaperCallClient
  include PaperCallAPI
  attr :from_file
  def initialize(from_file=false)
    @from_file = from_file
    fetch_submissions
    analyze
  end
end
