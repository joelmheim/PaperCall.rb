# Papercall

Papercall.io is a nice conference management system that allows you to put out a call for papers and manage the entire review process. This ruby-gem uses the Papercall API to fetch all the submitted papers and do some analysis.

Examples of the type of stats available are:
 * Number of papers in different states
 * Number of active reviewers
 * Number of submitted papers without any feedback
 * Number of papers missing reviews

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'papercall'
``````

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install papercall

## Usage

The following code will fetch all the submissions from your event and print a summary of stats:

```ruby
require 'papercall'

Papercall.fetch(:from_papercall, "<your api key>", :submitted, :accepted, :rejected, :waitlist, :declined)
Papercall.summary
```

The Papercall gem also allows you to fetch individual states, or just the ones you care about:

```ruby
Papercall.fetch(:from_papercall, "<your api key", :submitted, :accepted)
```
or
```ruby
Papercall.fetch(:from_papercall, "<your api key", :rejected, :declined, :waitelist)
```
The order does not matter.

You can also use this shortcut if you want to fetch all:
```ruby
Papercall.fetch(:from_papercall, "<your api key", :all)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelmheim/papercall. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
