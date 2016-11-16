module Clickmeetings
  module Open
    class Registration < Model
      include WithConference

      attr_accessor :registration_date, :registration_confirmed, :fields, :session_id,
                    :email, :visitor_nickname, :url, :r, :http_referer, :country, :city

      class << self
        def for_session(session_id: nil)
          Session.by_conference(conference_id: conference_id).new(id: session_id).registrations
        end

        def create(params = {})
          Conference.new(id: conference_id).register(params)
        end
      end
    end
  end
end
