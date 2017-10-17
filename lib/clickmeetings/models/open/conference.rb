module Clickmeetings
  module Open
    class Conference < Model
      set_resource_name "conferences"

      attr_accessor :id, :room_type, :room_pin, :name, :name_url, :description,
                    :access_type, :lobby_description, :status, :created_at,
                    :updated_at, :permanent_room, :ccc, :starts_at, :ends_at,
                    :access_role_hashes, :room_url, :phone_listener_pin,
                    :phone_presenter_pin, :embed_room_url, :recorder_list, :account_id,
                    :password, :settings, :autologin_hashes, :autologin_hash, :skin_id,
                    :registration_enabled, :registration, :associations_api_key

      class << self
        def all
          active + inactive
        end

        %w(active inactive).each do |m|
          define_method m do
            response = Clickmeetings.with_client(client_options) do
              Clickmeetings.client.get remote_url(__method__), default_params, default_headers
            end
            handle_response response
          end
        end

        def skins
          Clickmeetings.with_client(client_options) do
            Clickmeetings.client.get remote_url(__method__), default_params, default_headers
          end
        end
      end

      def create_tokens(how_many = 1)
        Token.by_conference(conference_id: id) do
          Token.create(how_many: how_many)
        end
      end

      def create_hash(params = {})
        LoginHash.create params.merge(conference_id: id)
      end

      def send_invites(params)
        Invitation.send_emails params.merge(conference_id: id)
      end

      %w(tokens sessions registrations recordings).each do |m|
        define_method m do
          const = "Clickmeetings::Open::#{m.singularize.capitalize}".constantize
          const.with_account(account_api_key: associations_api_key || api_key) do
            const.by_conference(conference_id: id) do
              const.all
            end
          end
        end
      end

      def files
        FileLibrary.for_conference(conference_id: id)
      end

      def register(params = {})
        Clickmeetings.with_client(client_options) do
          Clickmeetings.client.post remote_url('registration', id: id),
            params.merge(default_params), default_headers
        end
      end
    end
  end
end
