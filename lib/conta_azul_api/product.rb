# frozen_string_literal: true
require 'ostruct'

module ContaAzulApi
  module Product
    class NotFound < StandardError; end

    PRODUCT_ENDPOINT = 'v1/products'
    MAX_PRODUCTS_PER_PAGE = 200

    def self.find(product_id)
      product = ContaAzulApi::Request.get(endpoint: "#{PRODUCT_ENDPOINT}/#{product_id}")
      raise NotFound if product.nil?

      OpenStruct.new(product)
    end

    def self.all
      products = ContaAzulApi::Request.get(endpoint: "#{PRODUCT_ENDPOINT}?size=#{MAX_PRODUCTS_PER_PAGE}")

      products.map { |product| OpenStruct.new(product) }
    end

    def self.filter_by(name:)
      products = all

      products.select { |product| product.name.include?(name) }
    end
  end
end
