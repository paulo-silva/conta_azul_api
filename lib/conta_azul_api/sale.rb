# frozen_string_literal: true
require 'ostruct'
require 'conta_azul_api/models'

module ContaAzulApi
  class Sale < ::ContaAzulApi::Models
    class NotCreated < StandardError; end
    class NotDeleted < StandardError; end
    class NotFound < StandardError; end
    class NotUpdated < StandardError; end

    SALES_ENDPOINT = 'v1/sales'

    def self.find(id)
      sale_response = ContaAzulApi::Request.new.get(
        endpoint: "#{SALES_ENDPOINT}/#{id}", authorization: request_authorization
      )

      raise NotFound unless sale_response.success?

      OpenStruct.new(sale_response.body)
    end

    VALID_FILTER_OPTIONS = [
      :emission_start, :emission_end, :status, :customer_id, :page, :size
    ]
    def self.filter_by(**options)
      query_string =
        options
          .filter { |k, v| k.in? VALID_FILTER_OPTIONS }
          .map { |k, v| "#{k}=#{v}" }
          .join("&")

      response = ContaAzulApi::Request.new.get(
        endpoint: "#{SALES_ENDPOINT}?#{query_string}", authorization: request_authorization
      )

      raise NotFound unless response.success?

      response.body.map { |item| OpenStruct.new(item) }
    end

    def self.list_items(id)
      items_response = ContaAzulApi::Request.new.get(
        endpoint: "#{SALES_ENDPOINT}/#{id}/items", authorization: request_authorization
      )

      raise NotFound unless items_response.success?

      items_response.body.map { |item| OpenStruct.new(item) }
    end

    def self.update(id:, attributes: {})
      sale_response = ContaAzulApi::Request.new.put(
        endpoint: "#{SALES_ENDPOINT}/#{id}", body: attributes, authorization: request_authorization
      )

      raise NotUpdated unless sale_response.success?

      OpenStruct.new(sale_response)
    end

    def self.create(attributes = {})
      sale_response = ContaAzulApi::Request.new.post(
        endpoint: SALES_ENDPOINT, body: attributes, authorization: request_authorization
      )

      raise NotCreated unless sale_response.success?

      OpenStruct.new(sale_response.body)
    end

    def self.delete(id:)
      sale_response = ContaAzulApi::Request.new.delete(
        endpoint: "#{SALES_ENDPOINT}/#{id}", authorization: request_authorization
      )

      sale_response.status_code == :deleted
    end

    def self.delete!(id:)
      if delete(id: id)
        true
      else
        raise NotDeleted
      end
    end
  end
end

# {
#   "number": 12,
#   "emission": "2019-12-27T16:55:06.343Z",
#   "status": "COMMITTED",
#   "customer_id": "62d05442-5e02-4fb3-978b-da7e58e1f770",
#   "products": [
#     {
#       "description": "Game Atari ET",
#       "quantity": 2,
#       "product_id": "f8ffb77a-3d52-42d7-9bec-ea38c0ef043d",
#       "value": 50
#     }
#   ],
#   "services": [
#     {
#       "description": "Fix car engine",
#       "quantity": 1,
#       "service_id": "e78c6d82-501a-4045-90c4-ae5b520f58dc",
#       "value": 200
#     }
#   ],
#   "discount": {
#     "measure_unit": "VALUE",
#     "rate": 5
#   },
#   "payment": {
#     "type": "CASH",
#     "installments": [
#       {
#         "number": 1,
#         "value": 305,
#         "due_date": "2019-12-27T16:55:06.343Z",
#         "status": "PENDING"
#       }
#     ]
#   },
#   "notes": "Sale made by noon",
#   "shipping_cost": 10
# }
