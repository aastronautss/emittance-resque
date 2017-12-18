# Emittance::Resque

[![Build Status](https://travis-ci.org/aastronautss/emittance-resque.svg?branch=master)](https://travis-ci.org/aastronautss/emittance-resque)
[![Maintainability](https://api.codeclimate.com/v1/badges/c22a0799f16cb43c2063/maintainability)](https://codeclimate.com/github/aastronautss/emittance-resque/maintainability)
[![Inline docs](http://inch-ci.org/github/aastronautss/emittance-resque.svg?branch=master)](http://inch-ci.org/github/aastronautss/emittance-resque)

This is the Resque broker for the Emittance gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'emittance', '=> 0.0.6'
gem 'emittance-resque'
```

And then execute:

    $ bundle

Emittance::Resque requires any version of Emittance from 0.0.6 onward.

Or install it yourself as:

    $ gem install emittance
    $ gem install emittance-resque

## Usage

Use this as you would the standard Emittance gem. There are some limitations, which we'll get to in the next section.

First, we need to set the backend:

```ruby
Emittance.use_broker :resque
```

Then, we can watch for events:

```ruby
class MyKlass
  extend Emittance::Watcher

  def self.something_happened
    puts 'something happened!'
  end
end

MyKlass.watch :happening, :something_happened
```

Per the Emittance core library, this sets `MyKlass` up to call `.something_happened` whenever a `:happening` event (wrapped in an instance of `HappeningEvent`) gets emitted. Since we're using the Resque broker, this will occur in a Resque job.

```ruby
class MyEmitter
  extend Emittance::Emitter

  def self.make_something_happen
    puts 'something will happen'
    emit :happening
  end
end

MyEmitter.make_something_happen
# In the parent process log:
# something will happen!
#
# In the Resque process log:
# something happened!
```

## Limitations

At this time, Emittance::Resque can only register listeners as

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/emittance-resque. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Emittance::Resque project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/emittance-resque/blob/master/CODE_OF_CONDUCT.md).
