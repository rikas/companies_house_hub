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

  spec.add_dependency 'faraday', '~> 2.7'
end
