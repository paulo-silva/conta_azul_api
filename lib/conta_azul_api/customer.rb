# frozen_string_literal: true

require 'ostruct'
require 'conta_azul_api/models'

module ContaAzulApi
  class Customer < ::ContaAzulApi::Models
    class NotFound < StandardError; end
    class NotCreated < StandardError; end

    CUSTOMER_ENDPOINT = 'v1/customers'

    def self.create(attributes = {})
      customer = ContaAzulApi::Request.post(
        endpoint: "#{CUSTOMER_ENDPOINT}", body: attributes, authorization: request_authorization
      )

      raise NotCreated if customer.nil?

      OpenStruct.new(customer)
    end

    def self.find(customer_id)
      customer = ContaAzulApi::Request.get(
        authorization: request_authorization,
        body:          attributes,
        endpoint:      "#{CUSTOMER_ENDPOINT}/#{customer_id}"
      )

      raise NotFound if customer.nil?

      OpenStruct.new(customer)
    end

    def self.search(value)
      customers = ContaAzulApi::Request.get(
        authorization: request_authorization,
        endpoint:      "#{CUSTOMER_ENDPOINT}?search=#{value}"
      )

      customers.map { |customer| OpenStruct.new(customer) }
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
