module Clickmeetings
  module Open
    class Invitation < Model
      include WithConference
      include WithLocale

      set_resource_name 'invitation/email'

      attr_accessor :attendees, :role, :template

      class << self
        def send_emails(params = {})
          Storage.cm_current_conference =
            params.delete(:conference_id) if params[:conference_id].present?
          with_locale params.delete(:lang) do
            Clickmeetings.with_client(client_options) do
              Clickmeetings.client.post remote_url(locale),
                params.merge(default_params), default_headers
            end
          end
          new(params)
        end
      end

      def remote_url(action = nil, params = {})
        Conference.remote_path(:find, id: conference_id) + '/' + remote_path(action, params)
      end
    end
  end
end
