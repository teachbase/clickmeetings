# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clickmeetings/version'

Gem::Specification.new do |spec|
  spec.name          = "clickmeetings"
  spec.version       = Clickmeetings::VERSION
  spec.authors       = ["Sergei Alekseenko", "Makar Ermokhin"]
  spec.email         = ["alekseenkoss@gmail.com", "ermak95@gmail.com"]
  spec.summary       = %q{Simple REST API client for ClickMeetings Private Label API}
  spec.description   = %q{Simple REST API client for ClickMeetings Private Label API}
  spec.homepage      = "https://github.com/teachbase/clickmeetings"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2"
  spec.add_development_dependency 'pry', "~> 0.10"
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency "simplecov-gem-profile"
  spec.add_dependency "anyway_config", "~> 0", ">= 0.3"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "faraday_middleware", "~> 0.10"
  spec.add_dependency 'activemodel', ">= 4.1", "< 6"
  spec.add_dependency 'json', '~> 1.0'
end
