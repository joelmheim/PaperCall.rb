require 'spec_helper'
require 'papercall/models/presenter_profile'

describe PresenterProfile do
  before(:context) do
    @p = PresenterProfile.new({
                                  "name": "Joe Presenter",
                                  "bio": "Joe is a well-known speaker, has been worked as DevOps Lead last 10 years. She has confident communication, leadership skills across different levels, developed through international professional interaction and engagements with representatives of various government institutions or IT companies using agile environment across the world. Her social responsibility and communicative competence are demonstrated in the organization of professional networks, events and conferences. At the same time she gained public speaking skills through frequent academic presentations, workshops and participation as a speaker at IoT and DevOps conferences.",
                                  "twitter": "joey_joe",
                                  "company": "Hello Mobile",
                                  "url": "https://www.linkedin.com/in/joepresenter",
                                  "shirt_size": "Men's M",
                                  "email": "joe_presenter@mail.com",
                                  "location": "Pittsburgh, PA, USA",
                                  "avatar": "https://custom-avatar.com/users/joe_presenter/avatar1.jpg"
                              })
  end

  it 'has a name'do
    expect(@p.name).to eq "Joe Presenter"
  end

  it 'has a bio' do
    expect(@p.bio).not_to be_empty
  end

  it 'has a twitter handle' do
    expect(@p.twitter).to eq "joey_joe"
  end

  it 'has a company' do
    expect(@p.company).to eq "Hello Mobile"
  end

  it 'has an url' do
    expect(@p.url).to eq "https://www.linkedin.com/in/joepresenter"
  end

  it 'has a shirt_size' do
    expect(@p.shirt_size).to eq "Men's M"
  end

  it 'has an email address' do
    expect(@p.email).to eq "joe_presenter@mail.com"
  end

  it 'has a location' do
    expect(@p.location).to eq "Pittsburgh, PA, USA"
  end

  it 'has an avatar link' do
    expect(@p.avatar).to eq "https://custom-avatar.com/users/joe_presenter/avatar1.jpg"
  end
end