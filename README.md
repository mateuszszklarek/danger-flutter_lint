# danger-flutter_lint

[![Build Status](https://travis-ci.org/mateuszszklarek/danger-flutter_lint.svg?branch=master)](https://travis-ci.org/mateuszszklarek/danger-flutter_lint)
[![codecov](https://codecov.io/gh/mateuszszklarek/danger-flutter_lint/branch/master/graph/badge.svg)](https://codecov.io/gh/mateuszszklarek/danger-flutter_lint)

A Danger Plugin to lint dart files using `flutter analyze` command line interface.

## Installation

Add this line to your application's Gemfile:

	$ gem 'danger-fluter_lint'

Or install it yourself as:

    $ gem install danger-fluter_lint

## Usage

Just add to your Dangerfile

```rb
flutter_lint.lint
```

This will add markdown table with summary into your PR.

Or make Danger comment directly on the line instead of printing a Markdown table (GitHub only)

```rb
flutter_lint.lint(inline_mode: true)
```

*default value for inline_mode: false

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mateuszszklarek/danger-flutter_lint.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
