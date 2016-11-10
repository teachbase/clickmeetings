# Clickmeetings

Gem uses [clickmeeting](https://clickmeeting.com/) Private Label API to integrate its webinars into your Web-application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clickmeetings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clickmeetings

## Usage

### Configuration

With Rails you can write in `config/secrets.yml`:
```yaml
clickmeetings:
  privatelabel_api_key: your_api_key
```
If you want to use test platform [AnySecond](http://anysecond.com), you can add:
```yaml
privatelabel_host: http://api.anysecond.com/privatelabel/v1
```

Without Rails you can use:
```ruby
Clickmeetings.configure do |config|
  config.privatelabel_api_key = "your_api_key"
  config.privatelabel_host = "http://host.you.want.to/use"
end
```
or use environment variables `CLICKMEETINGS_PRIVATELABEL_API_KEY` and `CLICKMEETINGS_PRIVATELABEL_HOST`

### Integration

TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/teachbase/clickmeetings.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

