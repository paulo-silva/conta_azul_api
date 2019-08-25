require 'bundler/setup'
require 'conta_azul_api'
require 'webmock/rspec'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    ContaAzulApi.configure do |config|
      config.client_id     = ENV.fetch('CA_CLIENT_ID')      { 'XXXXXXXXX' }
      config.client_secret = ENV.fetch('CA_CLIENT_SECRET')  { 'YYYYYYYYY' }
      config.redirect_uri  = ENV.fetch('CA_REDIRECT_URI')   { 'https://myapp.com/auth' }
      config.scope         = ENV.fetch('CA_SCOPE')          { 'sales' }
      config.state         = ENV.fetch('CA_STATE')          { '' }
    end

    WebMock.disable_net_connect!
  end
end
