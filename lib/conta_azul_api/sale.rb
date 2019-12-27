# frozen_string_literal: true
require 'ostruct'
require 'conta_azul_api/models'

module ContaAzulApi
  class Sale < ::ContaAzulApi::Models
    class NotCreated < StandardError; end

    SALES_ENDPOINT = 'v1/sales'

    def self.create(attributes = {})
      sale_response = ContaAzulApi::Request.new.post(
        endpoint: SALES_ENDPOINT, body: attributes, authorization: request_authorization
      )

      raise NotCreated unless sale_response.success?

      OpenStruct.new(sale_response.body)
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
