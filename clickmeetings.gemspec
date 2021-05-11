# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clickmeetings/version'

Gem::Specification.new do |spec|
  spec.name          = 'clickmeetings'
  spec.version       = Clickmeetings::VERSION
  spec.authors       = ['Sergei Alekseenko', 'Makar Ermokhin']
  spec.email         = ['alekseenkoss@gmail.com', 'ermak95@gmail.com']
  spec.summary       = 'Simple REST API client for ClickMeetings Private Label and Open API'
  spec.description   = 'Simple REST API client for ClickMeetings Private Label and Open API'
  spec.homepage      = 'https://github.com/teachbase/clickmeetings'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-gem-profile'
  spec.add_development_dependency 'webmock', '~> 2'
  spec.add_dependency 'activemodel', '>= 4.1', '< 6'
  spec.add_dependency 'anyway_config', '>= 2.0'
  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware', '~> 0.10'
  spec.add_dependency 'json', '~> 1.0'
end
