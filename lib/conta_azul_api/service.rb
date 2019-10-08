# frozen_string_literal: true

require 'ostruct'
require 'conta_azul_api/models'

module ContaAzulApi
  class Service < ::ContaAzulApi::Models
    class NotFound < StandardError; end
    class BadRequest < StandardError; end
    class UnprocessableEntity < StandardError; end

    SERVICE_ENDPOINT = 'v1/services'

    def self.find(service_id)
      service_response = ContaAzulApi::Request.new.get(
        endpoint: "#{SERVICE_ENDPOINT}/#{service_id}", authorization: request_authorization
      )

      raise NotFound if service_response.status_code == :not_found

      OpenStruct.new(service_response.body)
    end

    def self.delete(service_id)
      service_response = ContaAzulApi::Request.new.delete(
        endpoint: "#{SERVICE_ENDPOINT}/#{service_id}", authorization: request_authorization
      )

      raise NotFound if service_response.status_code == :not_found

      true
    end

    def self.create(service_params)
      service_response = ContaAzulApi::Request.new.post(
        endpoint: SERVICE_ENDPOINT, body: service_params.to_json, authorization: request_authorization
      )

      raise BadRequest.new(service_response.body) if service_response.status_code == :bad_request

      OpenStruct.new(service_response.body) if service_response.success?
    end

    def self.update(service_id, service_params)
      service_response = ContaAzulApi::Request.new.put(
        endpoint: "#{SERVICE_ENDPOINT}/#{service_id}", authorization: request_authorization
      )

      raise NotFound if service_response.status_code == :not_found
      raise BadRequest.new(service_response.body) if service_response.status_code == :bad_request

      OpenStruct.new(service_response.body)
    end

    def self.find_by(params)
      service_response = ContaAzulApi::Request.new.get(
        endpoint: "#{SERVICE_ENDPOINT}?#{params.to_query}", authorization: request_authorization
      )

      raise BadRequest.new(service_response.body) if service_response.status_code == :bad_request

      service_response.body.map { |service| OpenStruct.new(service) }
    end
  end
end
