require "active_support/core_ext/module/attribute_accessors_per_thread"

module Clickmeetings
  class Storage
    thread_mattr_accessor :cm_current_conference, :cm_current_locale, :cm_open_current_account,
                  :cm_private_current_account
  end
end
