# RSpecOscalFormatter

This Library provides an RSpec Formatter that helps you to define tests that align with OSCAL Catalogs and SSPs, and produce Assessment Plan and Assessment Result documents based on the test results.

Original gem proof of concept can be found at https://github.com/Credentive-Sec/rspec_oscal_formatter

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rspec_oscal_formatter

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rspec_oscal_formatter

## Usage

See our [demo_spec.rb](./examples/demo_spec.rb) for a quick overview of how to use the formatters.

See [the Configuration class](./lib/rspec_oscal_formatter/configuration.rb) for global configuration options.

### Spec Metadata

To invoke the Oscal Formatter, tests must include at least `control_id: ""` and `statement_id: ""` metadata tags. These can be given on either the `it` test or `describe` or `context` blocks.

Optionally, pass `implementation_statement_uuid: 'YOUR_UUID'` to link the finding to the implementation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GSA-TTS/rspec_oscal_formatter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
