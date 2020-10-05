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
Once initialized just use the accessors as any other instance. 
```ruby
  class Issue
    include Binky::Struct

    def initialize(json = nil)
      super initialize json
    end
  end
  
  issue = Issue.new({id: 1234})
  issue.id # => 1234
```

### Used on ActiveRecord models
Binky-Builder includes another helper that can be used to initialize *ActiveRecord* models based on its column names.
In case not using column names but an array of method names, new accessors would be crated to access those methods.
```ruby
  class Issue < ApplicationRecord
    include Binky::Helper
  end
    
  issue = Issue.new.build_by_keys({id: 1234,text: "hocus pocus"},Issue.column_names) # => Issue.column_names = id:
  issue.as_json # => {id: 1234}
  issue.to_h # => nil
  
  issue = Issue.new.build_by_keys({id: 1234,text: "hocus pocus"}) # => Issue.column_names = id:
  issue.id # => {id: 1234}
  issue.text # => {text: "hocus pocus"}
  issue.as_json #=> {id: 1234,text: "hocus pocus"}
  issue.to_h # => nil
```


Call *build_by_keys* method once the model has been initialized passing a json message,
it would *yield* itself as a block in case you want to perform further actions. 
```ruby  
  build_by_keys(json = {},keys = nil) 
```
This method would also create an instance variable called *@to_h* contains a pair-value hash as a result. 
*@to_h* instance variable won't be available if the class inherits from *ActiveRecord::Base* 

### Auxiliary methods
Binky-Builder comes with two extra methods to search and create instance variable and methods.
It creates a instance variable along with its accessor methods (read/write).
```ruby  
  accessor_builder(key, value) 
```
This method goes through the whole object, being a hash, looking for the passed key and return the value found.
```ruby  
  nested_hash_value(obj, key) 
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
