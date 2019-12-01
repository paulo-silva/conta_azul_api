# frozen_string_literal: true

require 'ostruct'
require 'conta_azul_api/models'

module ContaAzulApi
  class Customer < ::ContaAzulApi::Models
    class NotFound < StandardError; end
    class NotCreated < StandardError; end

    CUSTOMER_ENDPOINT = 'v1/customers'

    def self.create(attributes = {})
      customer_response = ContaAzulApi::Request.new.post(
        endpoint: "#{CUSTOMER_ENDPOINT}", body: attributes, authorization: request_authorization
      )

      raise NotCreated unless customer_response.success?

      OpenStruct.new(customer_response.body)
    end

    def self.find(customer_id)
      customer_response = ContaAzulApi::Request.new.get(
        authorization: request_authorization,
        endpoint:      "#{CUSTOMER_ENDPOINT}/#{customer_id}"
      )

      raise NotFound if customer_response.status_code == :not_found

      OpenStruct.new(customer_response.body)
    end

    def self.search(value, size: 10)
      customer_response = ContaAzulApi::Request.new.get(
        authorization: request_authorization,
        endpoint:      "#{CUSTOMER_ENDPOINT}?search=#{value}&size=#{size}"
      )

      customer_response.body.map { |customer| OpenStruct.new(customer) }
    end

    def self.find_by_name(name)
      customer_response = ContaAzulApi::Request.new.get(
        authorization: request_authorization,
        endpoint:      "#{CUSTOMER_ENDPOINT}?name=#{name}"
      )

      customer_response.body.map { |customer| OpenStruct.new(customer) }
    end
  end
end

# {
#   "name": "John C.",
#   "company_name": "John Company",
#   "email": "john.company@johncompany.com",
#   "business_phone": "99 99999-9999",
#   "mobile_phone": "99 99999-9999",
#   "person_type": "NATURAL",
#   "document": "00011122233",
#   "identity_document": "00011122233",
#   "state_registration_number": "00011122233",
#   "state_registration_type": "NO_CONTRIBUTOR",
#   "city_registration_number": "00011122233",
#   "date_of_birth": "1988-12-23T08:32:10.118-05",
#   "notes": "Important customer, always wears a green hat",
#   "contacts": [
#     {
#       "name": "John C.",
#       "business_phone": "99 9999-9999",
#       "email": "John.C@johncompany.com",
#       "job_title": "Developer"
#     }
#   ],
#   "address": {
#     "zip_code": "79106-330",
#     "street": "Rua Parma",
#     "number": "224",
#     "complement": "Apartamento 2058",
#     "neighborhood": "Jardim Itália"
#   }
# }
