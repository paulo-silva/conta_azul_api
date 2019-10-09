require 'json'
require 'active_support/gzip'

module ContaAzulApi
  class HttpResponse
    def initialize(http_response)
      @raw_response = http_response
    end

    def status_code
      HTTP_STATUS_CODE[raw_response.code.to_sym]
    end

    def success?
      raw_response.code.start_with?('20')
    end

    def body
      format_response_body
    end

    private

    HTTP_STATUS_CODE = {
      '200': :ok,
      '201': :created,
      '400': :bad_request,
      '401': :unauthorized,
      '403': :forbidden,
      '404': :not_found,
      '422': :unprocessable_entity,
      '500': :internal_server_error,
      '503': :service_unavailabe
    }

    attr_reader :raw_response

    def format_response_body
      decompressed_data = ActiveSupport::Gzip.decompress(raw_response.body)

      JSON.parse(decompressed_data)
    rescue Zlib::GzipFile::Error # not a gzip
      JSON.parse(raw_response.body)
    end
  end
end
