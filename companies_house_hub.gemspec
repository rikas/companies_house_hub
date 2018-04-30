# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'companies_house_hub/version'

Gem::Specification.new do |spec|
  spec.name          = 'companies_house_hub'
  spec.version       = CompaniesHouseHub::VERSION
  spec.authors       = ['Ricardo Otero']
  spec.email         = ['oterosantos@gmail.com']
  spec.summary       = 'A REST client for the UK Companies House API'
  spec.description   = 'A REST client for the UK Companies House API, including authentication'
  spec.homepage      = 'https://github.com/rikas/companies_house_hub'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'dotenv', '~> 2.4.0'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '~> 0.54.0'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
