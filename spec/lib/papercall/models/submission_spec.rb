require 'spec_helper'
require 'papercall/models/submission'

describe Submission do
  before(:context) do
    @s = Submission.new(    {    "id": 6234,
                                                  "state": "accepted",
                                                  "confirmed": false,
                                                  "created_at": "2016-11-04T18:07:54.977Z",
                                                  "updated_at": "2017-08-03T02:51:40.059Z",
                                                  "additional_info": "Public speaking skills gained through frequent academic presentations, workshops (about 35 workshops in 2016, e.g., GEO-C Workshop, Workshops in the Delegation of the European Union 2013-2016, DevIt 2016, WTC 2016 San Jose etc.) and participation as a speaker at IoT and DevOps conferences (about 15 conferences in 2016 e.g., Geomundus, Modern problems of modeling in economics and innovation technologies, IoTSlam 2016, DevTalks 2016, Codemotion Milan, Codemotion Warsaw,, WTC 2016 San Jose, Voxxed Days Belgrade, Devoxx Morocco etc.). The community blogger of whatever mobile and IoT Agenda.",
                                                  "rating": 60,
                                                  "trust": 50,
                                                  "tags": [
                                                      "future",
                                                      "connectivity",
                                                      "ai",
                                                      "case study",
                                                      "methodology & architecture",
                                                      "iot"
                                                  ],
                                                  "co_presenter_profiles": [],
                                                  "profile": {
                                                      "name": "Joe Presenter",
                                                      "bio": "Joe is a well-known speaker, has been worked as DevOps Lead last 10 years. She has confident communication, leadership skills across different levels, developed through international professional interaction and engagements with representatives of various government institutions or IT companies using agile environment across the world. Her social responsibility and communicative competence are demonstrated in the organization of professional networks, events and conferences. At the same time she gained public speaking skills through frequent academic presentations, workshops and participation as a speaker at IoT and DevOps conferences.",
                                                      "twitter": "joey_joe",
                                                      "company": "Hello Mobile",
                                                      "url": "https://www.linkedin.com/in/joepresenter",
                                                      "shirt_size": "Men's M",
                                                      "email": "joe_presenter@mail.com",
                                                      "location": "Pittsburgh, PA, USA",
                                                      "avatar": "https://custom-avatar.com/users/joe_presenter/avatar1.jpg"
                                                  },
                                                  "talk": {
                                                      "title": "Amazing title",
                                                      "description": "The Internet of Things is converting the objects that surround us everyday into a community of information that will increase the quality of our lives.  From small devices to houses, the IoT is leading more and more things into the digital fold every day.  Sensors are necessary to turn billions of objects into data-generating “things” that can report on their status, and in some cases, interact with their environment.  At the moment, cities are at a crossroads where they must choose to either use or lose the transformative potential of big data. Advances in AI and the widespread availability of sensors have provided us with powerful applications that allow us to perform daily tasks by analyzing the huge amount of data.  The insights to be gained from data are endless.  In the light of this a new paradigm of combining AI and IoT has emerged, in which the quality of life could be increased through the use of big data and cloud technology. ",
                                                      "notes": "My current mission is to enable developers to realize innovation in the field of IoT. That's why I want to share my knowledge about m2m communication, IoT and the fields of application of multi network SIM cards in this context. With the help of new feature as REST API for SIM cards, we can all create so many new ideas together and be able to easily collect data for our projects.",
                                                      "abstract": "During last year we realized that Artificial Intelligence is functionally necessary to bring the number of sensor devices online. It definitely will be more important in making sense of data streamed in from IoT devices. What will happen when we will learn how to combine AI, IoT and general tools?",
                                                      "audience_level": "Beginner",
                                                      "talk_format": "Experience Report Presentation (30 minutes)"
                                                  },
                                                  "cfp_additional_question_answers": []
                                     })
  end

  it 'has an id' do
    expect(@s.id).to be 6234
  end

  it 'has a state' do
    expect(@s.state).to eq "accepted"
  end

  it 'has a confirmed flag' do
    expect(@s.confirmed?).to be false
  end

  it 'has a created at timestamp' do
    expect(@s.created_at).to eq Time.parse("2016-11-04T18:07:54.977Z")
  end

  it 'has an update at timestamp' do
    expect(@s.updated_at).to eq Time.parse("2017-08-03T02:51:40.059Z")
  end

  it 'has additional info' do
    expect(@s.additional_info).not_to be_empty
  end

  it 'has a rating' do
    expect(@s.rating).to be 60
  end

  it 'has a trust' do
    expect(@s.trust).to be 50
  end

  it 'has tags' do
    expect(@s.tags).to eq [
                              "future",
                              "connectivity",
                              "ai",
                              "case study",
                              "methodology & architecture",
                              "iot"
                          ]
  end

  it 'has co presenter profiles' do
    expect(@s.co_presenter_profiles.length).to be 0
  end

  it 'has a presenter profile with name' do
    expect(@s.presenter_profile.name).to eq "Joe Presenter"
  end

  it 'has a talk' do
    expect(@s.talk).not_to be_nil
  end

  it 'has cfp additional question answers' do
    expect(@s.cfp_additional_answers.length).to be 0
  end
end