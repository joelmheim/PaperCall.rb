require 'spec_helper'
require 'papercall/models/feedback'

describe Feedback do
  before(:context) do
    @f = Feedback.new({
                          "id": 2176,
                          "submission_id": 6237,
                          "talk_id": 12047,
                          "user": {
                              "name": "Reviewer Critical",
                              "avatar": "https://secure.gravatar.com/avatar/notarealavataraddress?s=500",
                              "email": "reviewer@critical.org"
                          },
                          "body": "Hi Submitter,\r\n\r\nThanks for your submission!\r\n\r\nRegards,\r\n\r\nReviewer",
                          "created_at": "2016-11-05T18:00:34.096Z",
                          "updated_at": "2016-11-05T18:00:34.096Z"
                      })
  end

  it 'has an id' do
    expect(@f.id).to be 2176
  end

  it 'has a submission id' do
    expect(@f.submission_id).to be 6237
  end

  it 'has a talk id' do
    expect(@f.talk_id).to be 12047
  end

  it 'has a user' do
    expect(@f.user).not_to be_nil
  end

  it 'has a text body' do
    expect(@f.body).not_to be_empty
  end

  it 'has a created date' do
    expect(@f.created_at).to eq Time.parse("2016-11-05T18:00:34.096Z")
  end

  it 'has a updated date' do
    expect(@f.updated_at).to eq Time.parse("2016-11-05T18:00:34.096Z")
  end
end
