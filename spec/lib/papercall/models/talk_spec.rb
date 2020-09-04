require 'spec_helper'
require 'papercall/models/talk'

describe Talk do
  before(:context) do
    @t = Talk.new({
                      "title": "Amazing title",
                      "description": "The Internet of Things is converting the objects that surround us everyday into a community of information that will increase the quality of our lives.  From small devices to houses, the IoT is leading more and more things into the digital fold every day.  Sensors are necessary to turn billions of objects into data-generating “things” that can report on their status, and in some cases, interact with their environment.  At the moment, cities are at a crossroads where they must choose to either use or lose the transformative potential of big data. Advances in AI and the widespread availability of sensors have provided us with powerful applications that allow us to perform daily tasks by analyzing the huge amount of data.  The insights to be gained from data are endless.  In the light of this a new paradigm of combining AI and IoT has emerged, in which the quality of life could be increased through the use of big data and cloud technology. ",
                      "notes": "My current mission is to enable developers to realize innovation in the field of IoT. That's why I want to share my knowledge about m2m communication, IoT and the fields of application of multi network SIM cards in this context. With the help of new feature as REST API for SIM cards, we can all create so many new ideas together and be able to easily collect data for our projects.",
                      "abstract": "During last year we realized that Artificial Intelligence is functionally necessary to bring the number of sensor devices online. It definitely will be more important in making sense of data streamed in from IoT devices. What will happen when we will learn how to combine AI, IoT and general tools?",
                      "audience_level": "Beginner",
                      "talk_format": "Experience Report Presentation (30 minutes)"
                  })
  end

  it 'has a title'do
    expect(@t.title).to eq "Amazing title"
  end

  it 'has a description' do
    expect(@t.description).not_to be_empty
  end

  it 'has notes' do
    expect(@t.notes).not_to be_empty
  end

  it 'has an abstract' do
    expect(@t.abstract).not_to be_empty
  end

  it 'has an audience level' do
    expect(@t.audience_level).to eq "Beginner"
  end

  it 'has a talk format' do
    expect(@t.talk_format).to eq "Experience Report Presentation (30 minutes)"
  end
end