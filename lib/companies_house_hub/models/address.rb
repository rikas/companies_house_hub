# frozen_string_literal: true

require 'companies_house_hub/base_model'

module CompaniesHouseHub
  class Address < BaseModel
    attr_reader :address_line1, :address_line2, :postal_code, :locality, :country

    def initialize(json = {})
      p json
      @address_line1 = json.dig(:address_line_1)
      @address_line2 = json.dig(:address_line_2)
      @country = json.dig(:country)
      @postal_code = json.dig(:postal_code)
      @locality = json.dig(:locality)
    end

    def full
      [@address_line1, @address_line2, @locality, @postal_code].compact.join(', ')
    end
  end
end
