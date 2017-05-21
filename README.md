# Logchange

[![Build Status](https://travis-ci.org/harigopal/logchange.svg?branch=master)](https://travis-ci.org/harigopal/logchange)

Logchange is an alternative approach to managing a _changelog_. Instead of writing to a flat `CHANGELOG(.md)`, it logs
changes to `.yaml` files containing a `timestamp`, the `title`, and a boolean `public`.

Logchange allows for two _release_ changelogs to be maintained - an exhaustive one for internal use, and a public one
 to display to your users. It can _release_ a public and a private changelog with one command, assuming that `public`
 boolean is correctly set (see _Usage_ section).

This repository's _changelog_ is maintained using _logchange_. Since this is a public repository, there are only public
changes. See the automatically generated `changelog/2017-public.yaml`. Unreleased changes go to `changelog/unreleased`.

## Why?

It's good to let your users know what you're up to, and it's good to keep track of what changed over time. However, you
don't need to tell your users about every single change - hence the `public` flag. The _YAML_ format just makes it
easier to parse and _present_ the data on the front-end, while being readable and editable.

## Installation

Add to your `Gemfile`:

    gem 'logchange', '~> 0.1'

And then:

    $ bundle install

Or install the gem with:

    $ gem install logchange

## Usage

If you've just completed work on a feature, log it with:

    $ logchange new "A cool new feature has been added"
    Created [..]/changelog/unreleased/20170521-a-cool-new-feature-has-been-added.yml`

This will create a new timestamped `.yaml` file in the `changelog` folder. By default, the `public` flag for all changes
will be set to `true`. You can change this if you want to prevent it from appearing in the release log.

To alter the default template used, create a `changelog/template.yaml` file, and set custom keys in it:

    # changelog/template.yaml

    public: false
    github_issue: Add a link to related Github issue, or delete this key.

If present, this template will be merged into the output.

To _release_ all new _public_ changes to the flat file, run:

    $ logchange release [VERSION]

## Change template

    ---
    timestamp: 2017-05-21T06:45:08Z
    title: The title for your change goes here. This string gets added to CHANGELOG.md upon release.
    public: Defaults to 'true'. This means that the release command will add this change to CHANGELOG.md. Set to 'false' to prevent that.
    additional_key_1: You can add any number of additional keys. Logchange will ignore these when writing CHANGELOG.md. Parsing / using these is up to you.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/harigopal/logchange.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

