# frozen_string_literal: true
require 'ostruct'
require 'conta_azul_api/models'

module ContaAzulApi
  class Product < ::ContaAzulApi::Models
    class NotFound < StandardError; end

    PRODUCT_ENDPOINT = 'v1/products'
    MAX_PRODUCTS_PER_PAGE = 1000

    def self.find(product_id)
      product_response = ContaAzulApi::Request.new.get(
        endpoint: "#{PRODUCT_ENDPOINT}/#{product_id}", authorization: request_authorization
      )
      raise NotFound if product_response.status_code == :not_found

      OpenStruct.new(product_response.body)
    end

    def self.all
      products_response = ContaAzulApi::Request.new.get(
        endpoint: "#{PRODUCT_ENDPOINT}?size=#{MAX_PRODUCTS_PER_PAGE}", authorization: request_authorization
      )

      products_response.body.map { |product| OpenStruct.new(product) }
    end

    def self.filter_by(name:)
      products = all

      products.select { |product| product.name.include?(name) }
    end
  end
end
