# frozen_string_literal: true

module ContaAzulApi
  class Authentication
    def initialize
      @last_authentication = ::CaAuthHistory.last
    end

    def access_token
      refresh_access_token

      @last_authentication.access_token
    end

    def refresh_token
      @last_authentication&.refresh_token
    end

    def authentication_expired?
      return true if @last_authentication.nil?

      @last_authentication.expires_at.to_i < Time.now.to_i
    end

    def request_access_token(grant_type:, code:)
      case grant_type
      when :refresh_token
        query_vars = "grant_type=refresh_token&refresh_token=#{code}"
      when :authorization_code
        redirect_uri = ContaAzulApi.configuration.redirect_uri

        query_vars = "grant_type=authorization_code&redirect_uri=#{redirect_uri}&code=#{code}"
      else
        raise InvalidGrantType
      end

      new_access_tokens = ContaAzulApi::Request.post(
        endpoint: "oauth2/token?#{query_vars}",
        authorization: "Basic #{client_credential}"
      )

      @last_authentication = ::CaAuthHistory.create!(
        access_token:  new_access_tokens['access_token'],
        refresh_token: new_access_tokens['refresh_token'],
        expires_at: Time.now + (new_access_tokens['expires_in'] - 60)
      )
    end

    def refresh_access_token
      if @last_authentication.nil?
        request_access_token(grant_type: :authorization_code, code: ContaAzulApi.configuration.auth_code)
      elsif authentication_expired?
        request_access_token(grant_type: :refresh_token, code: refresh_token)
      end
    end

    def client_credential
      @client_credential ||= begin
        client_credential = '%s:%s' % [ContaAzulApi.configuration.client_id, ContaAzulApi.configuration.client_secret]

        Base64.encode64(client_credential).gsub("\n", '')
      end
    end
  end
end
