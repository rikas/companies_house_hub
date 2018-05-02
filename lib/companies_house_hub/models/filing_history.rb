# frozen_string_literal: true

require 'companies_house_hub/filing_history_formatter'

module CompaniesHouseHub
  class FilingHistory < BaseModel
    DOCUMENT_URL = 'https://beta.companieshouse.gov.uk'
    FIND_PATH = '/company/:company_number/filing-history'
    DEFAULT_PER_PAGE = 100
    LEGACY_DOC_DESCRIPTION = 'legacy'

    attr_reader :description, :action_date, :date, :type, :barcode, :links, :description_values

    alias name description

    def self.all(options = {})
      options[:items_per_page] ||= DEFAULT_PER_PAGE

      number = options.delete(:company_number)

      result = get(format_url(FIND_PATH, company_number: number), options)

      return [] unless result.body[:items].any?

      # Get all items and create a new history. If the description is 'legacy' then we can safely
      # ignore that document.
      filing_histories = result.body[:items].map do |filing_json|
        next if filing_json.dig(:description) == LEGACY_DOC_DESCRIPTION

        new(filing_json)
      end

      filing_histories.compact
    end

    def initialize(json = {})
      @description = json.dig(:description)
      @action_date = json.dig(:action_date)
      @date = json.dig(:date)
      @type = json.dig(:type)
      @barcode = json.dig(:barcode)
      @links = json.dig(:links)
      @description_values = json.dig(:description_values)
    end

    def formatted_name
      FilingHistoryFormatter.new(self).formatted
    end

    def url(format = 'pdf')
      file_path = @links[:self]

      document_path = "#{file_path}/document?format=#{format}"

      URI.join(DOCUMENT_URL, document_path).to_s
    end
  end
end
