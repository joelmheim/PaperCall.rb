
class PresenterProfile
  attr_reader :name, :bio, :twitter, :company, :url, :shirt_size, :email, :location, :avatar

  def initialize(json_hash = {})
    @name = json_hash[:name]
    @bio = json_hash[:bio]
    @twitter = json_hash[:twitter]
    @company = json_hash[:company]
    @url = json_hash[:url]
    @shirt_size = json_hash[:shirt_size]
    @email = json_hash[:email]
    @location = json_hash[:location]
    @avatar = json_hash[:avatar]
  end
end