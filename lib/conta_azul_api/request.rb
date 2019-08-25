require 'pry'
require 'base64'
require 'json'
require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'

module ContaAzulApi
  module Request
    CONTA_AZUL_DOMAIN = 'https://api.contaazul.com/%s'
    HTTP_METHODS_CLASS = {
      post: Net::HTTP::Post,
      get:  Net::HTTP::Get
    }

    def self.get(endpoint:)
      request(method: :get, endpoint: endpoint)
    end

    def self.post(endpoint:, body: nil)
      request(method: :post, endpoint: endpoint, body: body)
    end

    private

    def self.request(method:, endpoint:, body: nil)
      url = URI(CONTA_AZUL_DOMAIN % endpoint)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http_method_class = HTTP_METHODS_CLASS[method]
      request = http_method_class.new(url)
      request['authorization'] = "Basic #{generate_base64_auth}"
      request.body = body

      response = http.request(request)
      JSON.parse(response.read_body)
    end

    def self.generate_base64_auth
      client_credential = '%s:%s' % [ContaAzulApi.configuration.client_id, ContaAzulApi.configuration.client_secret]

      Base64.encode64(client_credential).gsub("\n", '')
    end
  end
end
