require 'spec_helper'
require 'papercall/models/rating'

describe Rating do
  before(:context) do
    @r = Rating.new({
                        "id": 29657,
                        "submission_id": 9260,
                        "value": 1,
                        "comments": "Comment 1",
                        "created_at": "2017-02-10T11:22:04.343Z",
                        "updated_at": "2017-02-10T11:22:04.343Z",
                        "user": {
                            "name": "Reviewer Critical",
                            "avatar": "https://secure.gravatar.com/avatar/notreallyanavataraddress?s=500",
                            "email": "reviewer@critical.org"
                        }
                    })
  end

  it 'has an id' do
    expect(@r.id).to be 29657
  end

  it 'has a submission id' do
    expect(@r.submission_id).to be 9260
  end

  it 'has a value' do
    expect(@r.value).to be 1
  end

  it 'has comments' do
    expect(@r.comments).to eq "Comment 1"
  end

  it 'has a created date' do
    expect(@r.created_at).to eq Time.parse("2017-02-10T11:22:04.343Z")
  end

  it 'has an updated date' do
    expect(@r.updated_at).to eq Time.parse("2017-02-10T11:22:04.343Z")
  end

  it 'has a reviewer' do
    expect(@r.reviewer).not_to be_nil
  end
end


