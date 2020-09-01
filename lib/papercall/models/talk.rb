
class Talk
  attr_reader :title, :description, :notes, :abstract, :audience_level, :talk_format

  def initialize(json_hash)
    @title = json_hash[:title]
    @description = json_hash[:description]
    @notes = json_hash[:notes]
    @abstract = json_hash[:abstract]
    @audience_level = json_hash[:audience_level]
    @talk_format = json_hash[:talk_format]
  end
end