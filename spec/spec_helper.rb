# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'json'
require 'bundler/setup'
require 'pry-byebug'
require 'companies_house_hub'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def json_data(filename)
  content = File.read(File.join(CompaniesHouseHub.root, 'spec', 'fixtures', "#{filename}.json"))

  JSON.parse(content, symbolize_names: true)
end
