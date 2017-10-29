module Papercall
  # Superclass for fetchers. A fetcher fetches submissions of different
  # categories and stores them in instance variables.
  class Fetcher
    attr_reader :submitted, :accepted, :rejected, :waitlist, :declined

    def all
      {
        submitted: @submitted,
        accepted: @accepted,
        rejected: @rejected,
        waitlist: @waitlist,
        declined: @declined
      }
    end

    def analysis
      all = @submitted
      all += @accepted
      all += @rejected
      all += @waitlist
      all += @declined
      all
    end
  end
end
