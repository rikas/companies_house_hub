# frozen_string_literal: true

module CompaniesHouseHub
  class Configuration
    attr_accessor :api_key

    def initialize
      @api_key = ''
    end
  end
end
