# frozen_string_literal: true

RSpec.describe CompaniesHouseHub::Company do
  let(:company_json) { json_data('test_company') }

  it 'has readers for all instance variables' do
    company = described_class.new(company_json)

    expect(company.number).to eq('08846630')
    expect(company.has_been_liquidated).to be_falsey
    expect(company.jurisdiction).to eq('england-wales')
    expect(company.name).to eq('My company')
    expect(company.date_of_creation).to eq('2014-01-15')
    expect(company.status).to eq('active')
    expect(company.type).to eq('ltd')
  end

  it 'creates an instance of an address' do
    company = described_class.new(company_json)

    expect(company.address).to be_an(CompaniesHouseHub::Address)
  end

  describe '.find' do
    it 'returns nil if the company is not found' do
      VCR.use_cassette('invalid_company') do
        expect(described_class.find('666')).to be_nil
      end
    end
  end
end
