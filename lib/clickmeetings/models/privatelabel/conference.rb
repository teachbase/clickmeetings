module Clickmeetings
  module PrivateLabel
    class Conference < Model
      attr_accessor :id, :room_type, :room_pin, :name, :name_url, :description,
                    :access_type, :lobby_description, :status, :created_at,
                    :updated_at, :permanent_room, :ccc, :starts_at, :ends_at,
                    :access_role_hashes, :room_url, :phone_listener_pin,
                    :phone_presenter_pin, :embed_room_url, :recorder_list, :account_id,
                    :password

      class NoAccountError < ::Clickmeetings::ClickmeetingError; end

      class << self
        def by_account(account_id: nil)
          Storage.cm_private_current_account = account_id
          if block_given?
            result = yield
            Storage.cm_private_current_account = nil
            result
          else
            self
          end
        end

        def find(id)
          fail Clickmeetings::PrivateLabel::Conference::NoAccountError if account_id.nil?
          super
        end

        def all
          fail Clickmeetings::PrivateLabel::Conference::NoAccountError if account_id.nil?
          response = Clickmeetings.with_client(client_options) do
            Clickmeetings.client.get remote_url(__method__), default_params
          end
          response = response["active_conferences"].to_a + response["inactive_conferences"].to_a
          handle_response response
        end

        def create(params = {})
          fail Clickmeetings::PrivateLabel::Conference::NoAccountError if account_id.nil?
          super
        end

        def account_id
          Storage.cm_private_current_account
        end
      end

      def initialize(params = {})
        super
        @account_id ||= self.class.account_id
      end

      def remote_url(action = nil, params = {})
        "#{Account.remote_path(:find, id: @account_id)}/#{remote_path(action, params)}"
      end

      def update(params = {})
        fail Clickmeetings::PrivateLabel::Conference::NoAccountError if @account_id.nil?
        super
      end

      def destroy
        fail Clickmeetings::PrivateLabel::Conference::NoAccountError if @account_id.nil?
        super
      end
    end
  end
end
