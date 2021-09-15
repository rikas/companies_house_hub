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

  describe '#search' do
    it 'returns a list of companies found' do
      VCR.use_cassette('search_HOKO') do
        companies = described_class.search('HOKO')

        expect(companies).to be_an(Array)
        expect(companies.size).to eq(20)
        expect(companies.first).to be_an(described_class)
      end
    end
  end

  describe '.find' do
    it 'returns nil if the company is not found' do
      VCR.use_cassette('invalid_company') do
        expect(described_class.find('666')).to be_nil
      end
    end

    it 'returns an instance of the company if it exists' do
      VCR.use_cassette('company_find_02200605') do
        company = described_class.find('02200605')

        expect(company).to be_an(described_class)
        expect(company.number).to eq('02200605')
        expect(company.has_been_liquidated).to be_falsey
        expect(company.jurisdiction).to eq('england-wales')
        expect(company.name).to eq('JOJO LIMITED')
        expect(company.date_of_creation).to eq('1987-11-30')
        expect(company.status).to eq('dissolved')
        expect(company.type).to eq('ltd')
      end
    end
  end
end
