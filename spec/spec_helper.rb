require "bundler/setup"
require "conta_azul_api"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    ContaAzulApi.configure do |config|
      config.client_id     = ENV['CA_CLIENT_ID']
      config.client_secret = ENV['CA_CLIENT_SECRET']
      config.redirect_uri  = ENV['CA_REDIRECT_URI']
      config.scope         = ENV['CA_REDIRECT_SCOPE']
      config.state         = ENV['CA_REDIRECT_STATE']
    end
  end
end
