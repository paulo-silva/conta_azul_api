module ContaAzulApi
  class Configuration
    attr_accessor :client_id, :client_secret, :redirect_uri, :scope, :state, :refresh_token

    def initialize
      @client_id     = nil
      @client_secret = nil
      @redirect_uri  = nil
      @scope         = nil
      @state         = nil
      @refresh_token = nil
    end
  end
end
