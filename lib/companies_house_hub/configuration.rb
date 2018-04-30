# frozen_string_literal: true

module CompaniesHouseHub
  class Configuration
    attr_accessor :api_key
    attr_writer :debug

    def initialize
      @api_key = ''
    end

    def debug?
      @debug
    end
  end
end
