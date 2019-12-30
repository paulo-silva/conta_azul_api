module ContaAzulApi
  module Helpers
    def self.stub_refresh_token
      WebMock.stub_request(:post, %r{https://api.contaazul.com/oauth2/token}).
        to_return(status: 200, body: File.read('spec/fixtures/refresh_oauth_token.json'), headers: {})
    end
  end
end
