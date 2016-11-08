require 'clickmeetings'
require 'rails'

module Clickmeetings
  # Clickmeeting Rails engine
  # Load Clickmeetings rake tasks
  class Engine < Rails::Engine
    rake_tasks do
      load File.expand_path("../../tasks/clickmeetings.rake", __FILE__)
    end
  end
end
