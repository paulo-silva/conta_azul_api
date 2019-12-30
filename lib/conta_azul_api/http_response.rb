require 'json'
require 'active_support/gzip'
require 'rails'

module ContaAzulApi
  class HttpResponse
    def initialize(http_response, logger: Rails.logger)
      @raw_response = http_response
      @response_code = @raw_response.code.to_i
      @logger = logger
    end

    def status_code
      HTTP_STATUS_CODE[response_code]
    end

    def success?
      response_code.between?(200, 299)
    end

    def body
      formatted_response_body = valid_json?(response_body) ? JSON.parse(response_body) : response_body

      logger.info("Response body: ```\n#{formatted_response_body.to_s}\n```, Status: #{raw_response.code}")

      formatted_response_body
    end

    private

    HTTP_STATUS_CODE = {
      200 => :ok,
      201 => :created,
      204 => :deleted,
      400 => :bad_request,
      401 => :unauthorized,
      403 => :forbidden,
      404 => :not_found,
      422 => :unprocessable_entity,
      500 => :internal_server_error,
      503 => :service_unavailabe
    }

    attr_reader :raw_response, :response_code, :logger

    def response_body
      @response_body ||= begin
        return unless raw_response.body.present?

        decompressed_data = ActiveSupport::Gzip.decompress(raw_response.body)

        decompressed_data
      rescue Zlib::GzipFile::Error # not a gzip
        raw_response.body
      end
    end

    def valid_json?(json_string)
      return false if json_string.nil?

      JSON.parse(json_string)

      true
    rescue JSON::ParserError => e
      false
    end
  end
end
