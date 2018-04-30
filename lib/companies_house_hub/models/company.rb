# frozen_string_literal: true

require 'companies_house_hub/base_model'
require 'companies_house_hub/models/address'
require 'companies_house_hub/models/filing_history'

module CompaniesHouseHub
  class Company < BaseModel
    SEARCH_PATH = '/search'
    FIND_PATH = '/company/:company_number'

    attr_reader :number, :name, :created_at, :address

    def self.search(name, per_page:, start:)
      options = { q: name, items_per_page: per_page, start_index: start }

      result = get(SEARCH_PATH, options)

      result.body.each { |company_json| new(company_json) }
    end

    def self.find(company_number, params = {})
      url = format_url(FIND_PATH, company_number: company_number.to_s)

      result = get(url, params)

      new(result.body)
    end

    def initialize(json = {})
      @number = json.fetch(:company_number)
      @has_been_liquidated = json.fetch(:has_been_liquidated)
      @jurisdiction = json.fetch(:jurisdiction)
      @name = json.fetch(:company_name)
      @created_at = json.fetch(:date_of_creation)
      @address = Address.new(json.fetch(:registered_office_address))
      @status = json.fetch(:company_status)
    end

    def filing_histories
      FilingHistory.all(company_number: @number)
    end

    def full_address
      @address.full
    end

    def active?
      @status == 'active'
    end
  end
end
