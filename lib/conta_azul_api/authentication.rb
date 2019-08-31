# frozen_string_literal: true

module ContaAzulApi
  class Authentication
    def initialize
      @last_authentication = CaAuthHistory.last
    end

    def access_token
      if authentication_expired?
        refresh_access_token
      end

      @last_authentication.access_token
    end

    def refresh_token
      @last_authentication&.refresh_token
    end

    def authentication_expired?
      return true if @last_authentication.nil? || (@last_authentication.expires_at < Time.now)

      false
    end

    def refresh_access_token
      refresh_token_from_config = ContaAzulApi.configuration.refresh_token
      query_vars = "grant_type=refresh_token&refresh_token=#{refresh_token || refresh_token_from_config}"
      new_access_tokens = ContaAzulApi::Request.post(endpoint: "oauth2/token?#{query_vars}")

      @last_authentication = CaAuthHistory.create!(
        access_token:  new_access_tokens['access_token'],
        refresh_token: new_access_tokens['refresh_token'],
        expires_at: Time.now + (new_access_tokens['expires_in'] - 60)
      )
    end
  end
end
