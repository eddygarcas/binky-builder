# Binky::Builder ![Travis](https://travis-ci.org/eddygarcas/binky-builder.svg) [![Gem Version](https://badge.fury.io/rb/binky-builder.svg)](https://badge.fury.io/rb/binky-builder)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'binky-builder'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install binky-builder

## Usage
OpenStruct and accessor builder modules.

### Used as OpenStruct
Initialize an instance using json data, including the Builder class on your class definition.
Once initialized just use the accessors as a normal class instance. 
```ruby
  class Issue
    include Binky::Builder
    alias :super_initialize :initialize

    def initialize(json = nil)
      super_initialize json
    end
  end
```

### Used on ActiveRecord models
Binky-Builder includes another helper that can be used to initialize *ActiveRecord* models based on its column names.
```ruby
class ChangeLog < ApplicationRecord
  include Binky::BuilderHelper
```

Call *initialize_by_keys* method once the model has been initialized passing a json message. 
This method will *yield* self as a block. This method will also create an instance variable called *@to_hash*.
```ruby  
build_by_keys(json = {})(&:column_names) 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eddygarcas/binky-builder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/binky-builder/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Binky::Builder project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/binky-builder/blob/master/CODE_OF_CONDUCT.md).
