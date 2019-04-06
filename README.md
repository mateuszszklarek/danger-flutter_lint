# danger-flutter_lint

[![Gem](https://img.shields.io/gem/v/danger-flutter_lint.svg)](https://rubygems.org/gems/danger-flutter_lint)
[![Build Status](https://travis-ci.org/mateuszszklarek/danger-flutter_lint.svg?branch=master)](https://travis-ci.org/mateuszszklarek/danger-flutter_lint)
[![codecov](https://codecov.io/gh/mateuszszklarek/danger-flutter_lint/branch/master/graph/badge.svg)](https://codecov.io/gh/mateuszszklarek/danger-flutter_lint)

A Danger Plugin to lint dart files using `flutter analyze` command line interface.

## Installation

Add this line to your application's Gemfile:

	$ gem 'danger-flutter_lint'

Or install it yourself as:

    $ gem install danger-flutter_lint

## Usage

Flutter Analyze doesn't give an option to generate report but you can achieve this easily using regular shell command (locally or on CI):

```sh
$ flutter analyze > flutter_analyze_report.txt
```

It will add output from `flutter analyze` command to `flutter_analyze_report.txt`.

Now you need to set `report_path` and invoke `lint` in your Dangerfile.

```ruby
flutter_lint.report_path = "flutter_analyze_report.txt"
flutter_lint.lint
```

This will add markdown table with summary into your PR.

Or make Danger comment directly on the line instead of printing a Markdown table (GitHub only)

```ruby
flutter_lint.lint(inline_mode: true)
```

Default value for `inline_mode` parameter is false.

#### Lint only added/modified files

If you're dealing with a legacy project, with tons of warnings, you may want to lint only new/modified files. You can easily achieve that, setting the `only_modified_files` parameter to `true`.

```ruby
flutter_lint.only_modified_files = true
flutter_lint.report_path = "flutter_analyze_report.txt"
flutter_lint.lint
```

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
