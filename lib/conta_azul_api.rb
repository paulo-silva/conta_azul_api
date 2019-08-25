require "conta_azul_api/configuration"
require "conta_azul_api/authentication"
require "conta_azul_api/request"
require "conta_azul_api/version"
require "conta_azul_api/product"

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
