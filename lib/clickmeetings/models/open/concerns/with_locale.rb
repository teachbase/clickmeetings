module Clickmeetings
  module Open
    module WithLocale
      extend ActiveSupport::Concern

      module ClassMethods
        def locale
          Storage.cm_current_locale || Clickmeetings.config.locale
        end

        def with_locale(lang = Clickmeetings.config.locale)
          Storage.cm_current_locale = lang
          result = yield if block_given?
          Storage.cm_current_locale = nil
          result
        end
      end
    end
  end
end