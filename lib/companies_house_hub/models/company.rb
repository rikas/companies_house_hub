# frozen_string_literal: true

require 'companies_house_hub/base_model'
require 'companies_house_hub/models/address'
require 'companies_house_hub/models/filing_history'

module CompaniesHouseHub
  class Company < BaseModel
    SEARCH_PATH = '/search'
    FIND_PATH = '/company/:company_number'

    attr_reader :number, :name, :created_at, :address, :type, :jurisdiction, :has_been_liquidated
    attr_reader :status, :accounts, :full_address

    alias company_number number
    alias company_name name
    alias date_of_creation created_at
    alias company_status status

    def self.search(name, per_page: nil, start: nil)
      options = { q: name, items_per_page: per_page, start_index: start }

      result = get(SEARCH_PATH, options)

      result.body[:items].map { |company_json| new(company_json) }
    end

    def self.find(company_number, params = {})
      url = format_url(FIND_PATH, company_number: company_number.to_s)

      result = get(url, params)

      return unless result.success?

      new(result.body)
    end

    def initialize(json = {})
      @number = json.dig(:company_number)
      @has_been_liquidated = json.dig(:has_been_liquidated)
      @jurisdiction = json.dig(:jurisdiction)
      @name = json.dig(:company_name) || json.dig(:title)
      @created_at = json.dig(:date_of_creation)
      @address = Address.new(json.dig(:registered_office_address) || json.dig(:address))
      @status = json.dig(:company_status)
      @type = json.dig(:type) || json.dig(:company_type)
      @accounts = json.dig(:accounts)
      @full_address = json.dig(:address_snippet) || @address.full
    end

    def filing_histories
      FilingHistory.all(company_number: @number)
    end

    def active?
      @status == 'active'
    end
  end
end
