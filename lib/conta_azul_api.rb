require 'conta_azul_api/configuration'
require 'conta_azul_api/authentication'
require 'conta_azul_api/request'
require 'conta_azul_api/http_response'
require 'conta_azul_api/version'
require 'conta_azul_api/product'
require 'conta_azul_api/customer'
require 'conta_azul_api/service'
require 'conta_azul_api/sale'

module ContaAzulApi
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.authentication
    @authentication ||= Authentication.new
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
