# Logchange

Logchange is an alternative approach to managing a _changelog_. Instead of writing to a `CHANGELOG.md`, it logs changes to `.yaml` files. Each change gets its own file, with conventions that govern metadata.

Logchange can _release_ changes to a traditional flat `CHANGELOG.md` file. All changes (marked public) since the last one, will be added to this file.

This repository's _changelog_ is maintained using _logchange_. See the automatically generated `CHANGELOG.md` and individual entries in the `/changes` directory. Go ahead, have a look.

## Why?

Do you work in a team with other programmers? Want a simpler way to log different changes, and commit messages won't do? `logchange` can help.

## Installation

Install the gem with:

    $ gem install logchange

## Usage

If you've just completed work on a feature, log it with:

    $ logchange new "A cool new feature has been added"
    Created ./changes/20170521020858-a-cool-new-feature-has-been-added.yml`

This will create a new timestamped `.yaml` file in the `changes` folder.

You can also create a template `.yaml` file with:

    $ logchange template

This will create a change file with all the default keys used by Logchange.

To _release_ all new changes to the flat file, run:

    $ logchange release [VERSION]

You can preview what'll be added to `CHANGELOG.md` by running:

    $ logchange preview

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/harigopal/logchange.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

