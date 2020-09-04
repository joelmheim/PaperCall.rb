
class User
  attr_reader :name, :avatar, :email

  def initialize(json_hash)
    @name = json_hash[:name]
    @avatar = json_hash[:avatar]
    @email = json_hash[:email]
  end
end