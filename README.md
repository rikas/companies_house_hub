# CompaniesHouseHub
A wrapper around the [Companies House Rest API](https://developer.companieshouse.gov.uk/api/docs/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'companies_house_hub'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install companies_house_hub

## Setup

Set up CompaniesHouseHub in a block:

```ruby
CompaniesHouseHub.configure do |config|
  config.api_token = <YOUR_TOKEN>
end
```

## Usage

Search for company by name:

```ruby
CompaniesHouseHub::Company.search('NAME')
```

Find company by company number:

```ruby
CompaniesHouseHub::Company.find('08846630')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which
will create a git tag for the version, push git commits and tags, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rikas/companies_house_hub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
