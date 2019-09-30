# ContaAzulApi
[![Build Status](https://api.travis-ci.org/paulo-silva/conta_azul_api.svg?branch=master)](https://travis-ci.org/paulo-silva/conta_azul_api)
[![Code Climate](https://codeclimate.com/github/paulo-silva/conta_azul_api.svg)](https://codeclimate.com/github/paulo-silva/conta_azul_api)


## Installation

### Gem Setup

Add this line to your application's Gemfile:

```ruby
gem 'conta_azul_api', git: 'https://github.com/paulo-silva/conta_azul_api'
```

And then execute:

    $ bundle

In your terminal, run the code below inside your project path to create the migration of the `CaAuthHistory` table that will save tokens created every time that the previous one expires:

    $ rails g conta_azul_api:install copy_migrations

After that, run the migration:

    $ rails db:migrate

### Gem configuration

To start using ContaAzulApi, you need to create an initializer file (ex: `config/initializers/conta_azul_api.rb`) containing information about your application credential at ContaAzul. If you don't have one, you can create it on [this link](https://portaldevs.contaazul.com/). After that, you will have access to your application `client_id`, `client_secret` and `redirect_uri` defined by you. With this information, you can now request your authorization code that will be used to request to ContaAzul. To do so, request the following URL on your browser:

`https://api.contaazul.com/auth/authorize?redirect_uri={redirect_uri}&client_id={client_id}&scope=sales&state={state}`

The state variable is optional, its a unique string value of your choice that is hard to guess to prevent [CSRF](https://en.wikipedia.org/wiki/Cross-site_request_forgery).

Attached to the `redirect_uri` will be two important URL arguments that you need to read from the request:

- code: The OAuth 2.0 authorization code (your `auth_code`)
- state: A value used to test for possible CSRF attacks

Provide each information on ContaAzulApi initializer file, as shown below:

```ruby
ContaAzulApi.configure do |config|
  config.client_id     = ENV.fetch('CA_CLIENT_ID')
  config.client_secret = ENV.fetch('CA_CLIENT_SECRET')
  config.redirect_uri  = ENV.fetch('CA_REDIRECT_URI')
  config.scope         = ENV.fetch('CA_SCOPE')
  config.state         = ENV.fetch('CA_STATE')
  config.auth_code     = ENV.fetch('CA_AUTH_CODE')
end
```

That's it! You're ready to rock!

## Usage

TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paulo-silva/conta_azul_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ContaAzulApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/conta_azul_api/blob/master/CODE_OF_CONDUCT.md).
