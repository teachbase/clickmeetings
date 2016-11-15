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
        attr_reader :account_id

        def by_account(account_id: nil)
          @account_id = account_id
          self
        end

        def find(id)
          fail Clickmeetings::PrivateLabel::Conference::NoAccountError if @account_id.nil?
          super
        end

        def all
          fail Clickmeetings::PrivateLabel::Conference::NoAccountError if @account_id.nil?
          response = Clickmeetings.with_client(client_options) do
            Clickmeetings.client.get remote_url(__method__)
          end
          response = response["active_conferences"] + response["inactive_conferences"]
          handle_response response
        end

        def create(params = {})
          fail Clickmeetings::PrivateLabel::Conference::NoAccountError if @account_id.nil?
          super
        end
      end

      def initialize(params = {})
        super
        @account_id ||= self.class.account_id
      end

      def remote_url(action = nil, params = {})
        url = Account.remote_path(:find, id: @account_id) + '/' + remote_path(action, params)
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
