# frozen_string_literal: true

RSpec.describe CompaniesHouseHub::FilingHistory do
  it 'generates a barcode if it is nil' do
    params = {
      description: 'incorporation-company',
      action_date: '1948-03-10',
      date: '1980-11-03',
      type: 'NEWINC',
      links: {
        self: '/company/04685029/filing-history/MDExMTcxMjc4MmFkaXF6a2N4'
      }
    }

    filing_history = described_class.new(params)

    expect(filing_history.barcode).not_to be_nil
  end

  it 'uses the barcode from companies house if present' do
    params = {
      description: 'incorporation-company',
      action_date: '1948-03-10',
      date: '1980-11-03',
      type: 'NEWINC',
      links: {
        self: '/company/04685029/filing-history/MDExMTcxMjc4MmFkaXF6a2N4'
      },
      barcode: 'B4RC0D3'
    }

    filing_history = described_class.new(params)

    expect(filing_history.barcode).to eq('B4RC0D3')
  end

  describe '#url' do
    describe 'when links[:self] missing' do
      let(:params) do
        {
          category: 'incorporation',
          type: 'NEWINC',
          description: 'incorporation-company',
          date: '2013-08-13',
          links: {
            document_metadata: 'https://frontend-doc-api.companieshouse.gov.uk/document/8hxefY-BlkpaS8T75tCdh3c-HPifDApSSlSrWgvAJSw'
          },
          barcode: 'X2EMX0AQ',
          transaction_id: 'MzA4MzExOTM4NWFkaXF6a2N4'
        }
      end

      it 'builds url from company_number and transaction_id when company number is present' do
        filing_history = described_class.new(params, '08647669')

        expect(filing_history.url).to eq('https://beta.companieshouse.gov.uk/company/08647669/filing-history/MzA4MzExOTM4NWFkaXF6a2N4/document?format=pdf')
      end

      it 'is nullified when company_number is missing' do
        filing_history = described_class.new(params)

        expect(filing_history.url).to be_nil
      end
    end

    describe 'when links[:self] present' do
      let(:params) do
        {
          description: 'mortgage-create-with-deed-with-charge-number-charge-creation-date',
          action_date: '2019-05-29',
          category: 'mortgage',
          date: '2019-06-05',
          links: {
            self: '/company/08647669/filing-history/MzIzNjQ5MjYyMGFkaXF6a2N4',
            document_metadata: 'https://frontend-doc-api.companieshouse.gov.uk/document/4zXiVoo9uXwp2lvAdPpSszD2NwPjR0dKBEmyCJb8gr8'
          },
          subcategory: 'create',
          type: 'MR01',
          paper_filed: true,
          pages: 6,
          barcode: 'A86Y3WRN',
          transaction_id: 'MzIzNjQ5MjYyMGFkaXF6a2N4'
        }
      end

      it 'builds url from provided link' do
        filing_history = described_class.new(params)

        expect(filing_history.url).to eq('https://beta.companieshouse.gov.uk/company/08647669/filing-history/MzIzNjQ5MjYyMGFkaXF6a2N4/document?format=pdf')
      end

      it 'is nullified when links[:document_metadata] is missing' do
        filing_history = described_class.new(
          params.merge(links: { self: '/company/08647669/filing-history/MzIzNjQ5MjYyMGFkaXF6a2N4' })
        )

        expect(filing_history.url).to be_nil
      end
    end
  end

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
