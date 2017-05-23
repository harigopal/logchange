# Logchange

[![Build Status](https://travis-ci.org/harigopal/logchange.svg?branch=master)](https://travis-ci.org/harigopal/logchange)

Logchange is an alternative approach to managing a _changelog_. Instead of writing to a flat `CHANGELOG(.md)`, it logs
changes to `.yaml` files containing a `timestamp` and a `title`. You can extend this format by adding any number of
additional fields by specifying a template - allowing customization of the changelog to suit your needs.

Logchange allows you to _release_ changes; this allows you to group changes into versioned releases, or
timed releases, depending on what your project needs. New entries are kept in `changelog/unreleased` until the `release`
command is used to append it to `changelog/YEAR.yaml` file.

This repository's _changelog_ is maintained using _logchange_. See the automatically generated `changelog/2017.yaml`.
Unreleased changes (if any) go to `changelog/unreleased`.

## Why?

It's good to let your users know what you're up to, and it's good to keep track of what changed over time. If your
project's code isn't public, it might make sense to include a `private` flag in your template and use that to show only
a select list of changes to your users and the public. The _YAML_ format allows the changelog to be extended to fit your
specific requirements. It also makes it easy to parse and _present_ the data on the front-end.

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
    Created [..]/changelog/unreleased/20170521-a-cool-new-feature-has-been-added.yml

This will create a new timestamped `.yaml` file in the `changelog/unreleased` folder.

```yaml
timestamp: 2017-05-21T06:45:08Z
title: The title for your change goes here.
```

To extend the default template used, create `changelog/template.yaml`. See customization instructions below.

To _release_ all new _public_ changes to the flat file, run:

    $ logchange release [TAG]

This will add all _unreleased_ changes to `changelog/YEAR.yaml`. The current set of changes will be grouped together,
and the time of release will be recorded. You can optionally specify a _tag_ such as a version number. For example:

    $ logchange release v0.1.1

This will group current set of changes and add a `tag` key along with the release `timestamp`.

### Customize the template

Create a `changelog/template.yaml` file to add additional keys for information that you'd like to track in your project.

```yaml
# There will two keys by default - timestamp and title.
# You can add any number of additional keys - this depends on your workflow.
# A few examples are below.

description: Add more detailed information about the change?
github_issue_link: Add link to related Github issue.
private: Hide this change from the public? Set to true or false.
```

### Interactive mode

If the template is customized, you can use Logchange's interactive mode to supply required data, instead of passing it
directly via the command:

    $ logchange new
    title: A cool new feature has been added.

    github_issue_link: Add link to related Github issue.
    https://github.com/harigopal/logchange/issues/1

    private: Hide this change from the public? Set to true or false.
    false

    Created [..]/changelog/unreleased/20170521-a-cool-new-feature-has-been-added.yml

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/harigopal/logchange.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

