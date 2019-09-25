module FakeCaAuthHistory
  class CaAuthHistory
    attr_accessor :access_token, :refresh_token, :expires_at

    def initialize(access_token:, refresh_token:, expires_at:)
      @access_token = access_token
      @refresh_token = refresh_token
      @expires_at = expires_at
    end
  end

  def self.last
    nil
  end

  def self.create!(args)
    CaAuthHistory.new(
      access_token: args[:access_token],
      refresh_token: args[:refresh_token],
      expires_at: args[:expires_at]
    )
  end
end
