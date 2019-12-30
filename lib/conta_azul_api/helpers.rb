module ContaAzulApi
  module Helpers
    def self.stub_refresh_token
      body = {
        "refresh_token": "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY",
        "token_type": "bearer",
        "access_token": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "expires_in": 3600
      }.to_json

      WebMock.stub_request(:post, %r{https://api.contaazul.com/oauth2/token}).
        to_return(status: 200, body: body, headers: {})
    end
  end
end
