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

      company_number = options.delete(:company_number)

      result = get(format_url(FIND_PATH, company_number: company_number), options)

      return [] unless result.body[:items].any?

      # Get all items and create a new history. If the description is 'legacy' then we can safely
      # ignore that document.
      filing_histories = result.body[:items].map do |filing_json|
        next if filing_json.dig(:description) == LEGACY_DOC_DESCRIPTION

        new(filing_json, company_number)
      end

      filing_histories.compact
    end

    def initialize(json = {}, company_number = nil)
      @description = json.dig(:description)
      @action_date = json.dig(:action_date)
      @date = json.dig(:date)
      @type = json.dig(:type)
      @links = json.dig(:links)
      @transaction_id = json.dig(:transaction_id) # helps on barcode generation
      @barcode = json.dig(:barcode) || generate_barcode
      @description_values = json.dig(:description_values)
      @company_number = company_number
    end

    def formatted_name
      FilingHistoryFormatter.new(self).formatted
    end

    def url(format = 'pdf')
      file_path = @links[:self] || build_file_path

      return unless file_path

      document_path = "#{file_path}/document?format=#{format}"

      URI.join(DOCUMENT_URL, document_path).to_s
    end

    private

    # Sometimes the barcode comes as nil for some reason so we generate one based on the url. If the
    # URL is also not defined then we hope for the best and use other variables.
    def generate_barcode
      string = @links[:self] if @links
      string ||= [@description, @type, @transaction_id].compact.join

      Digest::SHA1.hexdigest(string)[0..6].upcase
    end

    def build_file_path
      required = [@company_number, @transaction_id].all? { |val| val && !val.empty? }

      "/company/#{@company_number}/filing-history/#{@transaction_id}" if required
    end
  end
end
