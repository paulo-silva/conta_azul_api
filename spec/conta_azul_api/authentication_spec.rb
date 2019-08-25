require 'timecop'

RSpec.describe ContaAzulApi::Authentication do
  describe '.authentication_expired?' do
    it 'returns positive when no access token is provided' do
      authentication = ContaAzulApi::Authentication.new

      expect(authentication.authentication_expired?).to be_truthy
    end

    it 'returns positive when access token is expired' do
      stub_request(:post, %r{https://api.contaazul.com/oauth2/token}).
        to_return(status: 200, body: File.read('spec/fixtures/refresh_oauth_token.json'), headers: {})

      authentication = ContaAzulApi::Authentication.new
      authentication.refresh_access_token

      Timecop.freeze(Time.now + 7200) do
        expect(authentication.authentication_expired?).to be_truthy
      end
    end

    it 'returns negative when access token is up to date' do
      stub_request(:post, %r{https://api.contaazul.com/oauth2/token}).
        to_return(status: 200, body: File.read('spec/fixtures/refresh_oauth_token.json'), headers: {})

      authentication = ContaAzulApi::Authentication.new
      authentication.refresh_access_token

      expect(authentication.authentication_expired?).to be_falsy
    end
  end
end
