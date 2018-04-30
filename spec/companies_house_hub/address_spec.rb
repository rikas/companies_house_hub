# frozen_string_literal: true

RSpec.describe CompaniesHouseHub::Address do
  it 'has readers for all instance variables' do
    add = described_class.new(
      address_line_1: 'Line1',
      address_line_2: 'Line2',
      locality: 'Local',
      postal_code: 'POSTAL',
      country: 'Portugal'
    )

    expect(add.address_line1).to eq('Line1')
    expect(add.address_line2).to eq('Line2')
    expect(add.locality).to eq('Local')
    expect(add.postal_code).to eq('POSTAL')
    expect(add.country).to eq('Portugal')
  end

  describe '#full' do
    it 'returns the full address correctly' do
      add = described_class.new(
        address_line_1: 'Line1',
        address_line_2: 'Line2',
        locality: 'Local',
        'postal_code': 'POSTAL'
      )

      expected = 'Line1, Line2, Local, POSTAL'

      expect(add.full).to eq(expected)
    end

    it 'returns the full address even when there are missing parts' do
      add = described_class.new(
        address_line_1: 'Line1',
        locality: 'Local'
      )

      expected = 'Line1, Local'

      expect(add.full).to eq(expected)
    end
  end
end
