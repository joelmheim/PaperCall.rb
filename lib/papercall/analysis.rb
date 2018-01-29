module Papercall
  class Analysis
    def initialize submissions
      @analysis = {}
      @analysis['submissions'] = submissions
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
    end

    def analyze
      startTime = Time.now
      print "Performing analysis..."
      @analysis['submissions'].each do |submission|
        submission["ratings"].each do |rating|
          unless(@analysis['reviewers'].include?(rating["user"]["name"]))
            @analysis['reviewers'][rating["user"]["name"]] = [{:id => rating["submission_id"]}]
          else
            @analysis['reviewers'][rating['user']['name']] << {:id => rating["submission_id"]}
          end
        end
        @analysis['talksWithoutReviews'] << {:id => submission["id"], :submission => submission} if submission["ratings"].empty?
        @analysis['talksWithFourOrMoreReviews'] << {:id => submission["id"], :submission => submission} if submission["ratings"].size >= 4
        @analysis['talksWithLessThanThreeReviews'] << {:id => submission["id"], :submission => submission} if submission["ratings"].size < 3
        @analysis['talksWithoutFeedback'] << {:id => submission["id"], :submission => submission} if submission["feedback"].empty?
        @analysis['highlyRated'] << {:id => submission["id"], :submission => submission} if highlyRated? submission
        @analysis['lowRated'] << {:id => submission["id"], :submission => submission} if lowRated? submission
        @analysis['maybe'] << {:id => submission["id"], :submission => submission} if maybe? submission
        @analysis['accepted'] << {:id => submission["id"], :submission => submission} if accepted? submission
        @analysis['waitlist'] << {:id => submission["id"], :submission => submission} if waitlisted? submission
        @analysis['rejected'] << {:id => submission["id"], :submission => submission} if rejected? submission
        @analysis['confirmed'] << {:id => submission["id"], :submission => submission} if confirmed? submission
      end
      @analysis['summary'] = summary
      puts "finished in #{Time.now - startTime} seconds."
      @analysis
    end

    private

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
  end
end
