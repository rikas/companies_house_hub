# frozen_string_literal: true

require 'companies_house_hub/base_model'

module CompaniesHouseHub
  class Address < BaseModel
    attr_reader :address_line_1, :address_line_2, :postal_code, :locality, :country

    def initialize(json = {})
      @address_line1 = json.fetch(:address_line_1)
      @address_line2 = json.fetch(:address_line_2)
      @country = json.fetch(:country)
      @postal_code = json.fetch(:postal_code)
      @locality = json.fetch(:locality)
    end

    def full
      [@address_line1, @address_line2, @locality, @postal_code].compact.join(', ')
    end
  end
end
