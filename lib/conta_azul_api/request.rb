require 'base64'
require 'json'
require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'
require 'active_support/gzip'
require 'rails'

module ContaAzulApi
  module Request
    CONTA_AZUL_DOMAIN = 'https://api.contaazul.com/%s'
    HTTP_METHODS_CLASS = {
      post: Net::HTTP::Post,
      get:  Net::HTTP::Get
    }

    def self.get(endpoint:, authorization:)
      request(method: :get, endpoint: endpoint, authorization: authorization)
    end

    def self.post(endpoint:, body: nil, authorization:)
      request(method: :post, endpoint: endpoint, body: body, authorization: authorization)
    end

    private

    def self.request(method:, endpoint:, body: nil, authorization:)
      url = URI(CONTA_AZUL_DOMAIN % endpoint)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http_method_class = HTTP_METHODS_CLASS[method]
      request = http_method_class.new(url)
      request['authorization'] = authorization
      request.body = body

      Rails.logger.info("Requesting #{method.to_s} #{url} with body: #{body}")

      response = http.request(request)

      Rails.logger.info("Response body: ```\n#{response.read_body.to_s}\n```, Status: #{response.code}")

      if response.code.start_with?('20')
        format_response_body(response.read_body)
      end
    end

    def self.format_response_body(response_body)
      decompressed_data = ActiveSupport::Gzip.decompress(response_body)

      JSON.parse(decompressed_data)
    rescue Zlib::GzipFile::Error # not a gzip
      JSON.parse(response_body)
    end
  end
end
