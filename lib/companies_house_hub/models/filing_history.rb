# frozen_string_literal: true

module CompaniesHouseHub
  class FilingHistory < BaseModel
    DOCUMENT_URL = 'https://beta.companieshouse.gov.uk'
    FIND_PATH = '/company/:company_number/filing-history'
    DEFAULT_PER_PAGE = 100

    attr_reader :description, :action_date, :date, :type, :barcode, :links

    def self.all(options = {})
      options[:items_per_page] ||= DEFAULT_PER_PAGE

      number = options.delete(:company_number)

      result = get(format_url(FIND_PATH, company_number: number), options)

      result.body[:items].map { |filing_json| new(filing_json) }
    end

    def initialize(json = {})
      @description = json.dig(:description)
      @action_date = json.dig(:action_date)
      @date = json.dig(:date)
      @type = json.dig(:type)
      @barcode = json.dig(:barcode)
      @links = json.dig(:links)
    end

    def url(format = 'pdf')
      file_path = @links[:self]

      document_path = "#{file_path}/document?format=#{format}"

      URI.join(DOCUMENT_URL, document_path).to_s
    end
  end
end
