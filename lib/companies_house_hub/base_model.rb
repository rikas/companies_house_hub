# frozen_string_literal: true

module CompaniesHouseHub
  class BaseModel
    def self.get(path, params)
      CompaniesHouseHub.connection.get(path, params)
    end

    def get(path, params)
      self.class.get(path, params)
    end

    def self.format_url(url, params)
      formatted = url.dup

      params.each { |key, value| formatted.sub!(":#{key}", value) }

      formatted
    end

    def format_url(url, params)
      self.class.format_url(url, params)
    end
  end
end
