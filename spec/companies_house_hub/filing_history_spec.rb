# frozen_string_literal: true

RSpec.describe CompaniesHouseHub::FilingHistory do
  describe '.all' do
    it 'returns an array of FilingHistory objects' do
      VCR.use_cassette('filing_histories_for_02200605') do
        docs = described_class.all(company_number: '02200605')

        expect(docs.map(&:class).uniq).to eq([described_class])
      end
    end

    it 'returns the full list of histories if we also accept `legacy` docs' do
      stub_const('CompaniesHouseHub::FilingHistory::LEGACY_DOC_DESCRIPTION', 'bogus-description')

      VCR.use_cassette('filing_histories_for_02200605') do
        docs = described_class.all(company_number: '02200605')

        expect(docs.size).to eq(21)
      end
    end

    it 'returns only histories without `legacy`' do
      VCR.use_cassette('filing_histories_for_02200605') do
        docs = described_class.all(company_number: '02200605')

        expect(docs.size).to eq(12)
      end
    end

    it 'returns an empty string if the company has no filing histories' do
      VCR.use_cassette('filing_histories_for_BR014831') do
        docs = described_class.all(company_number: 'BR014831')

        expect(docs.size).to be_zero
      end
    end
  end

  describe '#formatted_name' do
    it 'delegates formatted name to FilingHistoryFormatter' do
      formatter_double = instance_double(CompaniesHouseHub::FilingHistoryFormatter)

      allow(CompaniesHouseHub::FilingHistoryFormatter).to receive(:new).and_return(formatter_double)
      allow(formatter_double).to receive(:formatted).and_return('HELLO WORLD!')

      filename = 'filing_histories/confirmation_statement_with_updates'
      history = described_class.new(json_data(filename))

      expect(history.formatted_name).to eq('HELLO WORLD!')
    end
  end
end
