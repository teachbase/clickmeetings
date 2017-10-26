module Clickmeetings
  module Open
    module WithConference
      extend ActiveSupport::Concern

      included { attr_accessor :conference_id }

      module ClassMethods
        def by_conference(conference_id: nil)
          Storage.cm_current_conference = conference_id
          if block_given?
            result = yield
            Storage.cm_current_conference = nil
            result
          else
            self
          end
        end

        def conference_id
          Storage.cm_current_conference
        end
      end

      def initialize(params = {})
        super
        @conference_id ||= self.class.conference_id
      end

      def remote_url(action = nil, params = {})
        Conference.remote_path(:find, id: conference_id) + '/' + remote_path(action, params)
      end
    end
  end
end
