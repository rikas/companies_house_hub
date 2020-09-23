# frozen_string_literal: true

require 'companies_house_hub/models/address'

module CompaniesHouseHub
  class Officer < BaseModel
    FIND_PATH = "/company/:company_number/officers"
    DEFAULT_PER_PAGE = 90

    attr_reader :name, :country_of_residence, :appointed_on, :nationality, :occupation
    attr_reader :officer_role, :address, :raw_json

    def self.all(options = {})
      options[:items_per_page] ||= DEFAULT_PER_PAGE

      company_number = options.delete(:company_number)

      result = get(format_url(FIND_PATH, company_number: company_number), options)

      items = result.body.dig(:items) || []

      return [] unless items.any?

      items.map { |officer_json| new(officer_json) }
    end

    def initialize(json = {})
      @name = json.dig(:name)
      @country_of_residence = json.dig(:country_of_residence)
      @appointed_on = json.dig(:appointed_on)
      @nationality = json.dig(:nationality)
      @occupation = json.dig(:occupation)
      @officer_role = json.dig(:officer_role)
      @address = Address.new(json.dig(:address))
      @raw_json = json
    end

    # The name comes as a string, for example: "SANTOS, Ricardo", where the first actually comes
    # last in the string.
    def first_name
      name = @name.split(',').last || ''
      name.strip
    end

    def last_name
      name = @name.split(',').first || ''
      name.capitalize.strip
    end
  end
end
