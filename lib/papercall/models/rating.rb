require_relative 'user'

class Rating
  attr_reader :id, :submission_id, :value, :comments, :created_at, :updated_at, :user

  def initialize(json_hash)
    @id = json_hash[:id]
    @submission_id = json_hash[:submission_id]
    @value = json_hash[:value]
    @comments = json_hash[:comments]
    @created_at = Time.parse(json_hash[:created_at])
    @updated_at = Time.parse(json_hash[:updated_at])
    @user = User.new(json_hash[:user])
  end
end