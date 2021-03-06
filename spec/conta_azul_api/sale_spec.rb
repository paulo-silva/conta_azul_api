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

  describe '.filter_by' do
    it 'returns sales based on provided filters' do
      stub_request(:get, "https://api.contaazul.com/v1/sales?emission_start=2020-10-13&size=1").
        to_return(status: 200, body: File.read('spec/fixtures/sales_endpoints/filter_by.json'))

      sales = ContaAzulApi::Sale.filter_by(emission_start: '2020-10-13', size: 1)
      expect(sales).to be_an(Array)
      expect(sales.length).to eq 1

      sale = sales.first
      expect(sale.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
      expect(sale.number).to eq(12)
      expect(sale.total).to eq(50)
    end

    it 'raises an error when sale is not found' do
      stub_request(:get, "https://api.contaazul.com/v1/sales?emission_start=2020-10-13&size=1").
        to_return(status: 404, body: 'Sales not found with the specified filters')

      expect {
        ContaAzulApi::Sale.filter_by(emission_start: '2020-10-13', size: 1)
      }.to raise_exception(ContaAzulApi::Sale::NotFound)
    end
  end

  describe 'list_items' do
    it 'returns items from a sale' do
      stub_request(:get, 'https://api.contaazul.com/v1/sales/c7288c09-829d-48b9-aee2-4f744e380587/items').
        to_return(status: 200, body: File.read('spec/fixtures/sales_endpoints/list_items.json'))

      items = ContaAzulApi::Sale.list_items('c7288c09-829d-48b9-aee2-4f744e380587')

      expect(items.size).to eq(1)
      expect(items.first['description']).to eq('Game Atari ET')
      expect(items.first['value']).to eq(0)
    end

    it 'raises an error when sale is not found' do
      stub_request(:get, 'https://api.contaazul.com/v1/sales/c7288c09-829d-48b9-aee2-4f744e380587/items').
        to_return(status: 404, body: File.read('spec/fixtures/sales_endpoints/list_items.json'))

      expect {
        ContaAzulApi::Sale.list_items('c7288c09-829d-48b9-aee2-4f744e380587')
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

      ContaAzulApi::Helpers.stub_create_sale(
        payload: sales_params,
        body: JSON.parse(File.read('spec/fixtures/sales_endpoints/create.json'))
      )

      new_sale = ContaAzulApi::Sale.create(sales_params.as_json)

      expect(new_sale.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
    end

    it 'raises error when sale is not created' do
      ContaAzulApi::Helpers.stub_create_sale(status: 422)

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
