module ContaAzulApi
  class Authentication
    attr_accessor :access_token, :refresh_token, :expires_in, :last_authentication

    def initialize
      @access_token = nil
      @refresh_token = nil
      @expires_in = nil
      @last_authentication = nil
    end

    def authentication_expired?
      return true if access_token.nil?

      Time.now.to_i > expires_in
    end

    def refresh_access_token
      refresh_token_from_config = ContaAzulApi.configuration.refresh_token
      query_vars = "grant_type=refresh_token&refresh_token=#{refresh_token || refresh_token_from_config}"
      new_access_tokens = ContaAzulApi::Request.post(endpoint: "oauth2/token?#{query_vars}")

      @access_token = new_access_tokens['access_token']
      @refresh_token = new_access_tokens['refresh_token']
      @last_authentication = Time.now.to_i
      @expires_in = last_authentication + new_access_tokens['expires_in']
    end
  end
end
