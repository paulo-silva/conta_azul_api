RSpec.describe ContaAzulApi::Sale do
  before do
    stub_request(:post, %r{https://api.contaazul.com/oauth2/token}).
      to_return(status: 200, body: File.read('spec/fixtures/refresh_oauth_token.json'))

    stub_const('CaAuthHistory', FakeCaAuthHistory)

    logger = double(:logger, info: '')
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe '.find' do
    it 'returns a sale based on provided id' do
      stub_request(:get, "https://api.contaazul.com/v1/sales/c7288c09-829d-48b9-aee2-4f744e380587").
        to_return(status: 200, body: File.read('spec/fixtures/sales_endpoints/find_by_id.json'))

      sale = ContaAzulApi::Sale.find('c7288c09-829d-48b9-aee2-4f744e380587')

      expect(sale.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
      expect(sale.number).to eq(12)
      expect(sale.total).to eq(50)
    end

    it 'raises an error when sale is not found' do
      stub_request(:get, "https://api.contaazul.com/v1/sales/c7288c09-829d-48b9-aee2-4f744e380587").
        to_return(status: 404, body: 'Sale not found with the specified id')

      expect {
        ContaAzulApi::Sale.find('c7288c09-829d-48b9-aee2-4f744e380587')
      }.to raise_exception(ContaAzulApi::Sale::NotFound)
    end
  end

  describe '.create' do
    it 'creates a sale when valid data is provided' do
      sales_params = {
        number: 1234,
        emission: '2019-12-27T16:55:06.343Z',
        status: 'COMMITTED',
        customer_id: 'c7288c09-829d-48b9-aee2-4f744e380587',
        products: [
          {
            description: "Game Atari ET",
            quantity: 2,
            product_id: "f8ffb77a-3d52-42d7-9bec-ea38c0ef043d",
            value: 50
          }
        ],
        payment: {
          type: 'CASH'
        },
        notes: 'PP2'
      }

      stub_request(:post, 'https://api.contaazul.com/v1/sales').
        with(body: sales_params).
        to_return(status: 201, body: File.read('spec/fixtures/sales_endpoints/create.json'), headers: {})

      new_sale = ContaAzulApi::Sale.create(sales_params.as_json)

      expect(new_sale.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
    end

    it 'raises error when sale is not created' do
      stub_request(:post, 'https://api.contaazul.com/v1/sales').
        with(body: {}).
        to_return(status: 422, body: nil, headers: {})

      expect {
        ContaAzulApi::Sale.create({}.as_json)
      }.to raise_exception(ContaAzulApi::Sale::NotCreated)
    end
  end

  describe '.delete' do
    it 'removes a sale based on provided id' do
      stub_request(:delete, "https://api.contaazul.com/v1/sales/c7288c09-829d-48b9-aee2-4f744e380587").
        to_return(status: 204, body: 'Sale deleted')

      sale_removed = ContaAzulApi::Sale.delete(id: 'c7288c09-829d-48b9-aee2-4f744e380587')

      expect(sale_removed).to be_truthy
    end

    it 'does not remove a sale when they are not found' do
      stub_request(:delete, "https://api.contaazul.com/v1/sales/c7288c09-829d-48b9-aee2-4f744e380587").
        to_return(status: 404, body: 'Sale not found with specified id')

      sale_removed = ContaAzulApi::Sale.delete(id: 'c7288c09-829d-48b9-aee2-4f744e380587')

      expect(sale_removed).to be_falsey
    end
  end

  describe '.delete!' do
    it 'removes a sale based on provided id' do
      stub_request(:delete, "https://api.contaazul.com/v1/sales/c7288c09-829d-48b9-aee2-4f744e380587").
        to_return(status: 204, body: 'Sale deleted')

      sale_removed = ContaAzulApi::Sale.delete!(id: 'c7288c09-829d-48b9-aee2-4f744e380587')

      expect(sale_removed).to be_truthy
    end

    it 'raises an error when sale is not found' do
      stub_request(:delete, "https://api.contaazul.com/v1/sales/c7288c09-829d-48b9-aee2-4f744e380587").
        to_return(status: 404, body: 'Sale not found with specified id')


      expect {
        ContaAzulApi::Sale.delete!(id: 'c7288c09-829d-48b9-aee2-4f744e380587')
      }.to raise_exception(ContaAzulApi::Sale::NotDeleted)
    end
  end
end
