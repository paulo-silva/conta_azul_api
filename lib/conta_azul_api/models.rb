module ContaAzulApi
  module Models
    def self.request_authorization
      "Bearer #{ContaAzulApi.authentication.access_token}"
    end
  end
end
