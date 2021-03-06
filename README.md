# HeaderableEtag

Use additional headers to caculate ETag

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'headerable_etag'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install headerable_etag

## Usage

Example of adding Cache-Control header into calculating ETag:

```ruby
config.middleware.insert_before(Rack::ETag, ::HeaderableEtag::Middleware, ['Cache-Control'])
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/liuming/headerable_etag.

