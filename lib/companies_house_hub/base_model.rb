# frozen_string_literal: true

require 'companies_house_hub/errors'

module CompaniesHouseHub
  class BaseModel
    def self.get(path, params)
      result = CompaniesHouseHub.connection.get(path, params)

      raise APIKeyError, result.body[:error] if result.status == 401

      result
    end

    def get(path, params)
      self.class.get(path.strip, params)
    end

    def self.format_url(url, params)
      formatted = url.dup.strip

      params.each { |key, value| formatted.sub!(":#{key}", value) }

      formatted
    end

    def format_url(url, params)
      self.class.format_url(url, params)
    end
  end
end
