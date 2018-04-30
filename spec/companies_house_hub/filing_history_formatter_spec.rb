# frozen_string_literal: true

RSpec.describe CompaniesHouseHub::FilingHistoryFormatter do
  describe '#formatted' do
    it 'returns the formatted name correctly for CS01' do
      filename = 'filing_histories/confirmation_statement_with_updates'
      history = CompaniesHouseHub::FilingHistory.new(json_data(filename))

      formatter = described_class.new(history)

      expected = 'confirmation-statement-made-on-2018-03-01-with-updates.pdf'

      expect(formatter.formatted).to eq(expected)
    end

    it 'returns the right file extension' do
      filename = 'filing_histories/confirmation_statement_with_updates'
      history = CompaniesHouseHub::FilingHistory.new(json_data(filename))

      formatter = described_class.new(history)

      expected = 'confirmation-statement-made-on-2018-03-01-with-updates.doc'

      expect(formatter.formatted('doc')).to eq(expected)
    end

    it 'returns the formatted name correctly for NEWINC' do
      filename = 'filing_histories/incorporation_company'
      history = CompaniesHouseHub::FilingHistory.new(json_data(filename))

      formatter = described_class.new(history)

      expected = 'incorporation.pdf'

      expect(formatter.formatted).to eq(expected)
    end

    it 'returns the formatted name correctly for PSC01' do
      filename = 'filing_histories/notification_of_a_person_with_significant_control'
      history = CompaniesHouseHub::FilingHistory.new(json_data(filename))

      formatter = described_class.new(history)

      expected = 'notification-of-Christopher-Geoffrey-Douglas-Hooper-as-a-person-with-' \
                 'significant-control-on-2017-06-01.pdf'

      expect(formatter.formatted).to eq(expected)
    end
  end
end
