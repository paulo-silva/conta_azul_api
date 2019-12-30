require 'active_support/gzip'

RSpec.describe ContaAzulApi::HttpResponse do
  let(:product_payload) { File.read('spec/fixtures/products_endpoints/find_by_id.json') }

  before do
    logger = double(:logger, info: '')
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe '#status_code' do
    context 'when it is a successfull request' do
      it 'returns the response status code' do
        stub_request(:get, 'https://api.contaazul.com/v1/products/c7288c09-829d-48b9-aee2-4f744e380587').
          to_return(status: 200, body: product_payload, headers: {})

        response = ContaAzulApi::Request.new.get(
          endpoint: 'v1/products/c7288c09-829d-48b9-aee2-4f744e380587',
          authorization: 'fake_auth'
        )
        expect(response.status_code).to eq(:ok)
      end
    end

    context 'when it is a unsuccessfull request' do
      it 'returns the response status code' do
        stub_request(:get, 'https://api.contaazul.com/v1/products/c7288c09-829d-48b9-aee2-4f744e380587').
          to_return(status: 404, body: product_payload, headers: {})

        response = ContaAzulApi::Request.new.get(
          endpoint: 'v1/products/c7288c09-829d-48b9-aee2-4f744e380587',
          authorization: 'fake_auth'
        )

        expect(response.status_code).to eq(:not_found)
      end
    end
  end

  describe '#success?' do
    context 'when it is a successfull request' do
      it 'returns true when success' do
        stub_request(:get, 'https://api.contaazul.com/v1/products/c7288c09-829d-48b9-aee2-4f744e380587').
          to_return(status: 200, body: product_payload, headers: {})

        response = ContaAzulApi::Request.new.get(
          endpoint: 'v1/products/c7288c09-829d-48b9-aee2-4f744e380587',
          authorization: 'fake_auth'
        )

        expect(response.success?).to be true
      end
    end

    context 'when it is a unsuccessfull request' do
      it 'returns true when success' do
        stub_request(:get, 'https://api.contaazul.com/v1/products/c7288c09-829d-48b9-aee2-4f744e380587').
          to_return(status: 404, body: product_payload, headers: {})

        response = ContaAzulApi::Request.new.get(
          endpoint: 'v1/products/c7288c09-829d-48b9-aee2-4f744e380587',
          authorization: 'fake_auth'
        )

        expect(response.success?).to be false
      end
    end
  end

  describe '#body' do
    it 'returns a hash format body' do
      stub_request(:get, 'https://api.contaazul.com/v1/products/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 200, body: product_payload, headers: {})

      response = ContaAzulApi::Request.new.get(
        endpoint: 'v1/products/c7288c09-829d-48b9-aee2-4f744e380587',
        authorization: 'fake_auth'
      )

      expect(response.body).to be_a Hash
      expect(response.body).to eq(JSON.parse(product_payload))
    end

    it 'returns a hash format when GZip is provided' do
      stub_request(:get, 'https://api.contaazul.com/v1/products/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 200, body: ActiveSupport::Gzip.compress(product_payload), headers: {})

      response = ContaAzulApi::Request.new.get(
        endpoint: 'v1/products/c7288c09-829d-48b9-aee2-4f744e380587',
        authorization: 'fake_auth'
      )

      expect(response.body).to be_a Hash
      expect(response.body).to eq(JSON.parse(product_payload))
    end
  end
end
