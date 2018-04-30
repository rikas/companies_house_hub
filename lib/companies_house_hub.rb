# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'companies_house_hub/configuration'
require 'companies_house_hub/base_model'

require 'companies_house_hub/models/company'

module CompaniesHouseHub
  API_URL = 'https://api.companieshouse.gov.uk'

  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def connection
    @connection ||= Faraday.new(url: API_URL) do |conn|
      conn.basic_auth(configuration.api_key, '')
      conn.use FaradayMiddleware::ParseJson
      conn.response :json, parser_options: { symbolize_names: true }
      conn.response :logger
      conn.adapter Faraday.default_adapter
    end
  end

  def configure
    yield configuration
  end
end
