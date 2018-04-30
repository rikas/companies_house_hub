# frozen_string_literal: true

RSpec.describe CompaniesHouseHub::Company do
  describe '.find' do
    it 'returns nil if the company is not found' do
      VCR.use_cassette('invalid_company') do
        expect(described_class.find('666')).to be_nil
      end
    end
  end
end
