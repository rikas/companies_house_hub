# frozen_string_literal: true

module CompaniesHouseHub
  class Person < BaseModel
    FIND_PATH = "/company/:company_number/persons-with-significant-control"
    DEFAULT_PER_PAGE = 90

    attr_reader :name, :nationality, :country_of_residence, :forename, :middle_name, :title
    attr_reader :surname, :address, :raw_json

    def self.all(options = {})
      options[:items_per_page] ||= DEFAULT_PER_PAGE

      company_number = options.delete(:company_number)

      result = get(format_url(FIND_PATH, company_number: company_number), options)

      # For some companies, for some reason, this endpoint returns an error, like this:
      # {
      #   "errors": [
      #     {
      #       "error": "company-psc-not-found",
      #       "type": "ch:service"
      #     }
      #   ]
      # }
      items = result.body.dig(:items) || []

      return [] unless items.any?

      items.map { |person_json| new(person_json) }
    end

    def initialize(json = {})
      @raw_json = json
      @name = json.dig(:name)
      @nationality = json.dig(:nationality)
      @address = Address.new(json.dig(:address))
      @forename = json.dig(:name_elements, :forename)
      @middle_name = json.dig(:name_elements, :middle_name)
      @title = json.dig(:name_elements, :title)
      @surname = json.dig(:name_elements, :surname)
    end
  end
end
