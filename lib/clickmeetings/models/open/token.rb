module Clickmeetings
  module Open
    class Token < Model
      class NoConferenceError < ::Clickmeetings::ClickmeetingError; end

      include WithConference

      set_resource_name "tokens"

      attr_accessor :token, :sent_to_email, :first_use_date

      class << self
        def all
          fail NoConferenceError if conference_id.nil?
          response = Clickmeetings.with_client(client_options) do
            Clickmeetings.client.get remote_url(__method__), default_params, default_headers
          end
          handle_response response["access_tokens"]
        end

        def create(params = {})
          fail NoConferenceError if conference_id.nil?
          response = Clickmeetings.with_client(client_options) do
            Clickmeetings.client.post remote_url(__method__), params.merge(default_params), default_headers
          end
          handle_response response["access_tokens"]
        end
      end

      def create_hash(params = {})
        LoginHash.create params.merge(conference_id: conference_id, token: token)
      end
    end
  end
end