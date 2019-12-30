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

    def self.stub_product(id:, data: {}, status: 200)
      WebMock.stub_request(:get, "https://api.contaazul.com/v1/products/#{id}")
        .to_return(status: status, body: data.to_json)
    end

    def self.stub_list_products(status: 200, products: [])
      WebMock.stub_request(:get, %r{https://api.contaazul.com/v1/products})
        .to_return(status: status, body: products.to_json)
    end
  end
end
