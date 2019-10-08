RSpec.describe ContaAzulApi::Service do
  before do
    stub_request(:post, %r{https://api.contaazul.com/oauth2/token}).
      to_return(status: 200, body: File.read('spec/fixtures/refresh_oauth_token.json'))

    stub_const('CaAuthHistory', FakeCaAuthHistory)

    logger = double(:logger, info: '')
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe '.find' do
    it 'returns a service when a valid ID is provided' do
      stub_request(:get, 'https://api.contaazul.com/v1/services/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 200, body: File.read('spec/fixtures/services_endpoints/find_by_id.json'))

      service = ContaAzulApi::Service.find('c7288c09-829d-48b9-aee2-4f744e380587')

      expect(service.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
      expect(service.name).to eq('Fix car engine')
    end

    it 'raises an error when product not found' do
      stub_request(:get, 'https://api.contaazul.com/v1/services/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 404)

      expect {
       ContaAzulApi::Service.find('c7288c09-829d-48b9-aee2-4f744e380587')
      }.to raise_exception(ContaAzulApi::Service::NotFound)
    end
  end

  describe '.delete' do
    it 'returns true indicating success when a service is deleted' do
      stub_request(:delete, 'https://api.contaazul.com/v1/services/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 204)

      expect(ContaAzulApi::Service.delete('c7288c09-829d-48b9-aee2-4f744e380587')).to be true
    end

    it 'raises an error when a service is not found' do
      stub_request(:delete, 'https://api.contaazul.com/v1/services/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 404)

      expect {
        ContaAzulApi::Service.delete('c7288c09-829d-48b9-aee2-4f744e380587')
      }.to raise_exception(ContaAzulApi::Service::NotFound)
    end
  end

  describe '.create' do
    it 'returns the new service when all parameters are correct' do
      params = {
        name: 'Fix car engine',
        value: 100,
        cost: 80,
        code: "FIX-ENG-001"
      }
      stub_request(:post, 'https://api.contaazul.com/v1/services').
        with(body: params.to_json).
        to_return(status: 201, body: File.read('spec/fixtures/services_endpoints/find_by_id.json'))

      service = ContaAzulApi::Service.create(params)

      expect(service.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
      expect(service.name).to eq('Fix car engine')
    end

    it 'raises an error when some parameter is wrong' do
      params = { }
      stub_request(:post, 'https://api.contaazul.com/v1/services').
        with(body: params.to_json).
        to_return(status: 400)

      expect {
        ContaAzulApi::Service.create(params)
      }.to raise_exception(ContaAzulApi::Service::BadRequest)
    end
  end

  describe '.find_by' do
    it 'returns a list of services' do
      stub_request(:get, 'https://api.contaazul.com/v1/services?cost=80').
        to_return(status: 200, body: File.read('spec/fixtures/services_endpoints/list_all.json'))

      services = ContaAzulApi::Service.find_by(cost: 80)

      expect(services.size).to eq(1)
    end
  end

  describe '.update' do
    it 'returns the updated service when all parameters are correct' do
      params = {
        name: 'Fix car engine',
        value: 100,
        cost: 80,
        code: "FIX-ENG-001"
      }
      stub_request(:put, 'https://api.contaazul.com/v1/services/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 200, body: File.read('spec/fixtures/services_endpoints/find_by_id.json'))

      service = ContaAzulApi::Service.update('c7288c09-829d-48b9-aee2-4f744e380587', params)

      expect(service.cost).to eq 80
      expect(service.name).to eq('Fix car engine')
    end

    it 'raises an error when the service does not exist' do
      params = {
        name: 'Fix car engine',
        value: 100,
        cost: 80,
        code: "FIX-ENG-001"
      }
      stub_request(:put, 'https://api.contaazul.com/v1/services/fake_service_id').
        to_return(status: 404)

      expect {
        ContaAzulApi::Service.update('fake_service_id', params)
      }.to raise_exception(ContaAzulApi::Service::NotFound)
    end

    it 'raises an error when params are invalid' do
      params = {
        price: 80,
        dash: "FIX-ENG-001"
      }

      stub_request(:put, 'https://api.contaazul.com/v1/services/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 400)

      expect {
        ContaAzulApi::Service.update('c7288c09-829d-48b9-aee2-4f744e380587', params)
      }.to raise_exception(ContaAzulApi::Service::BadRequest)
    end
  end
end
