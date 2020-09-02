require_relative 'presenter_profile'
require_relative 'talk'

class Submission
  attr_reader :id, :state, :confirmed, :created_at, :updated_at, :additional_info, :rating, :trust, :tags,
              :co_presenter_profiles, :presenter_profile, :talk, :cfp_additional_answers
  attr_accessor :ratings, :feedback

  def initialize(json_hash)
    @id = json_hash[:id]
    @state = json_hash[:state]
    @confirmed = json_hash[:confirmed]
    @created_at = Time.parse(json_hash[:created_at])
    @updated_at = Time.parse(json_hash[:updated_at])
    @additional_info = json_hash[:additional_info]
    @rating = json_hash[:rating]
    @trust = json_hash[:trust]
    @tags = json_hash[:tags]
    @co_presenter_profiles = json_hash[:co_presenter_profiles]
    @presenter_profile = PresenterProfile.new(json_hash[:profile])
    @talk = Talk.new(json_hash[:talk])
    @cfp_additional_answers = json_hash[:cfp_additional_question_answers]
    @ratings = []
    @feedback = []
  end

  def no_reviews?
    @ratings.empty?
  end

  def enough_reviews?
    @ratings.size >= 3
  end

  def too_many_reviews?
    @ratings.size >= 4
  end

  def highly_rated?
    @rating >= 75 && enough_reviews?
  end

  def low_rated?
    @rating <= 25 && enough_reviews?
  end

  def maybe?
    !accepted? && !rejected? && enough_reviews?
  end

  def accepted?
    @state == 'accepted'
  end

  def rejected?
    @state == 'rejected'
  end

  def waitlisted?
    @state == 'waitlist'
  end

  def confirmed?
    accepted? && @confirmed == true
  end

  def no_feedback?
    @feedback.empty?
  end

  def to_s
    puts "Submission: #{@id}, #{@talk.title}, #{@presenter_profile.name}. Number of reviews: #{@ratings.size}. Number of feedback: #{@feedback.size}"
  end
end