unless ENV['COVERAGE'].nil?
  require "simplecov"
  require "simplecov-gem-profile"

  SimpleCov.start "gem"
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'clickmeetings'
require 'pry-byebug'
require 'webmock/rspec'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }
Dir[File.expand_path("../helpers/**/*.rb", __FILE__)].each { |f| require f }
Dir[File.expand_path("../shared_examples/**/*.rb", __FILE__)].each { |f| require f }


RSpec.configure do |config|
  config.mock_with :rspec
  include ClickmeetingWebMock
  include FixturesHelpers

  config.example_status_persistence_file_path = File.expand_path("../../examples.txt", __FILE__)
end
