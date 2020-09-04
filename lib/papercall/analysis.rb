module Papercall
  class Analysis
    attr_reader :submissions,
                :reviewers,
                :talks_without_reviews,
                :talks_missing_reviews,
                :talks_with_many_reviews,
                :talks_without_feedback,
                :highly_rated,
                :low_rated,
                :maybe,
                :accepted,
                :waitlisted,
                :rejected,
                :confirmed,
                :summary

    def initialize submissions
      @output = Papercall.configuration.output
      @submissions = submissions
      @reviewers = {}
      @talks_without_reviews = []
      @talks_missing_reviews = []
      @talks_with_many_reviews = []
      @talks_without_feedback = []
      @highly_rated = []
      @low_rated = []
      @maybe = []
      @accepted = []
      @waitlisted = []
      @rejected = []
      @confirmed = []
      analyze
    end

    def number_of_submissions
      @submissions.size
    end

    def number_of_active_reviewers
      @reviewers.size
    end

    def number_without_feedback
      @talks_without_feedback.size
    end

    def number_completed
      @submissions.size - @talks_missing_reviews.size
    end

    def number_of_highly_rated
      @highly_rated.size
    end

    def number_of_low_rated
      @low_rated.size
    end

    def number_of_maybes
      @maybe.size
    end

    def number_with_few_reviews
      @talks_missing_reviews.size
    end

    def number_with_many_reviews
      @talks_with_many_reviews.size
    end

    def number_without_reviews
      @talks_without_reviews.size
    end

    def number_accepted
      @accepted.size
    end

    def number_of_waitlisted
      @waitlisted.size
    end

    def number_rejected
      @rejected.size
    end

    def number_confirmed
      @confirmed.size
    end


    private

    def analyze
      start_time = Time.now
      print 'Performing analysis...' if @output
      @submissions.each do |submission|
        submission.ratings.each do |rating|
          if !(@reviewers.include? rating.user.name)
            @reviewers[rating.user.name] = [{ id: rating.submission_id }]
          else
            @reviewers[rating.user.name] << { id: rating.submission_id }
          end
        end
        @talks_without_reviews << { id: submission.id, submission: submission } if submission.no_reviews?
        @talks_with_many_reviews << { id: submission.id, submission: submission } if submission.too_many_reviews?
        @talks_missing_reviews << {id: submission.id, submission: submission} unless submission.enough_reviews?
        @talks_without_feedback << { id: submission.id, submission: submission } if submission.no_feedback?
        @highly_rated << { id: submission.id, submission: submission } if submission.highly_rated?
        @low_rated << { id: submission.id, submission: submission } if submission.low_rated?
        @maybe << { id: submission.id, submission: submission } if submission.maybe?
        @accepted << { id: submission.id, submission: submission } if submission.accepted?
        @waitlisted << { id: submission.id, submission: submission } if submission.waitlisted?
        @rejected << { id: submission.id, submission: submission } if submission.rejected?
        @confirmed << { id: submission.id, submission: submission } if submission.confirmed?
      end
      @summary = build_summary
      puts "finished in #{Time.now - start_time} seconds." if @output
    end

    def build_summary
      summary = {}
      summary['numSubmissions'] = @submissions.size
      summary['numActiveReviewers'] = @reviewers.size
      summary['numWithoutFeedback'] = @talks_without_feedback.size
      summary['numCompleted'] = @submissions.size - @talks_missing_reviews.size
      summary['numHighlyRated'] = @highly_rated.size
      summary['numLowRated'] = @low_rated.size
      summary['numMaybe'] = @maybe.size
      summary['numLessThanThreeReviews'] = @talks_missing_reviews.size
      summary['numWithFourOrMoreReviews'] = @talks_with_many_reviews.size
      summary['numWithoutReviews'] = @talks_without_reviews.size
      summary['numAccepted'] = @accepted.size
      summary['numWaitlisted'] = @waitlisted.size
      summary['numRejected'] = @rejected.size
      summary['numConfirmed'] = @confirmed.size
      summary
    end

  end
end
