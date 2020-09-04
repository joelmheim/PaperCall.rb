require 'spec_helper'
require 'papercall/models/user'

describe User do
  before(:context) do
    @u = User.new({
                      "name": "Reviewer Critical",
                      "avatar": "https://secure.gravatar.com/avatar/notreallyanavataraddress?s=500",
                      "email": "reviewer@critical.org"
                  })
  end

  it 'has a name' do
    expect(@u.name).to eq "Reviewer Critical"
  end

  it 'has an avatar url' do
    expect(@u.avatar).to eq "https://secure.gravatar.com/avatar/notreallyanavataraddress?s=500"
  end

  it 'has an email' do
    expect(@u.email).to eq "reviewer@critical.org"
  end
end


