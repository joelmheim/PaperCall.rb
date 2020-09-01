require_relative 'user'

class Feedback
  attr_reader :id, :submission_id, :talk_id, :user, :body, :created_at, :updated_at

  def initialize(json_hash)
    @id = json_hash[:id]
    @submission_id = json_hash[:submission_id]
    @talk_id = json_hash[:talk_id]
    @user = User.new(json_hash[:user])
    @body = json_hash[:body]
    @created_at = Time.parse(json_hash[:created_at])
    @updated_at = Time.parse(json_hash[:updated_at])
  end
end