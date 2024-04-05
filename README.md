![GitHub License](https://img.shields.io/github/license/eclectic-coding/rails_app)
[![Tests](https://github.com/eclectic-coding/rails_app/actions/workflows/ci.yml/badge.svg)](https://github.com/eclectic-coding/rails_app/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/rails_app.svg)](https://badge.fury.io/rb/rails_app)
# RailsApp

RailsApp is a gem that provides a simple way to create a new Rails application with a pre-configured set of gems and settings, utilizing the Rails application templates feature.

The initial release of this gem is an opinionated template that includes the following dependencies and settings:
- Esbuild for JavaScript bundling
- Bootstrap for CSS styling
- RSpec for testing
- Code quality tools: Rubocop, Brakeman, and Bundler Audit

The initial release of this gem **v.0.1.0** is starting with my personal preferences and a Rails template I have developed locally. I plan to expand the template to include more options and configurations with future releases which will make this template less opinionated.

## Installation
Install globally:
```bash
gem install rails_app
```

## Usage
To bootstrap a new Rails application: `rails_app`

The user will be prompted to enter the name of the new Rails application, and the select the assets pipeline to use (propshaft or sprockets), and a styling option:

![](assets/screenshot_cli.png)

Also, you can select your database of choice:

![](assets/screenshot_cli_db.png)

The template will then create a new Rails application with the selected options.

### Optional CLI Syntax

There is an additional syntax, available starting with release `v. 0.7.0`, which allows you to use `rails_app` very similarly to the `rails new` command:


```bash
rails_app new my_app -a propshaft --css bootstrap -d postgresql
```
I few things to note:
- the `app_name` must be first, just like with `rails new`
- the following arguments and flags must be separated by a space `-a propshaft`. Since, the parser ignores the flag and checks for the specific keywords only, you technically can use the follow: `rails_app my_app propshaft bootstrap postgresql`. 

If you use this syntax, the template will not prompt you the application name, and subsequent options will be preselected for you.

Right not this syntax only supports the following options:
- app name
- assets pipeline
- styling
- database

More options will be added in future releases.

## Configuration
**NEW** Starting with release `v. 0.8.0`, you can save your preferred defaults to you users home directory (`rails_aap-config.yml`).
If a file has been previously saved, you will be prompted if you want to use:
![](assets/screenshot_cli_readconfig.png)


Then your options will be pre-selected:
![](assets/screenshot_cli_useconfig.png)

# Features
section coming soon 


## Testing
The template includes RSpec for testing, which includes pre configured:
- FactoryBot
- Faker
- Webmock
- VCR
- Simplecov

### Code Quality Tools
The template includes the following code quality tools:
- Rubocop using the `rubocop-rails-omakase` gem with a few custom settings in a provided `.rubocop.yml`
- Brakeman for security scanning
- Bundler Audit for checking for vulnerable gems

All of this tools can be run using the following command, which also will run the test suite: `bin/ci`

In addition, the template includes:
- the `annotate` gem to annotate models and and factories with schema information
- the `bullet` gem to help identify and remove N+1 queries

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eclectic-coding/rails_app.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
