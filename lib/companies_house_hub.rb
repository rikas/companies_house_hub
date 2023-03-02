# frozen_string_literal: true

require 'faraday'
require 'companies_house_hub/configuration'
require 'companies_house_hub/base_model'
require 'companies_house_hub/errors'
require 'companies_house_hub/models/company'
require 'companies_house_hub/models/person'
require 'companies_house_hub/models/officer'

module CompaniesHouseHub
  API_URL = 'https://api.companieshouse.gov.uk'

  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def connection
    @connection ||= Faraday.new(url: API_URL) do |conn|
      conn.request :authorization, :basic, configuration.api_key, ''
      conn.response :json, parser_options: { symbolize_names: true }
      conn.response :logger if configuration.debug?
      conn.adapter Faraday.default_adapter
    end
  end

  def configure
    yield configuration
  end

  def root
    File.expand_path('../', __dir__)
  end

  def load_yml(name)
    YAML.load_file(File.join(root, 'data', "#{name}.yml"))
  end
end
