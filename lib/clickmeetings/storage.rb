require 'active_support/per_thread_registry'

module Clickmeetings
  class Storage
    extend ActiveSupport::PerThreadRegistry

    attr_accessor :cm_current_conference, :cm_current_locale, :cm_open_current_account,
                  :cm_private_current_account
  end
end
