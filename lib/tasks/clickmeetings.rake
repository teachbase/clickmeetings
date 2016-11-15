require 'clickmeetings'

namespace :clickmeetings do
  desc "Check Clickmeetings configuration."
  task :check do
    p Clickmeetings.config.inspect
  end
end
