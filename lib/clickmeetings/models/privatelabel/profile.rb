module Clickmeetings
  module PrivateLabel
    class Profile < ::Clickmeetings::Model
      set_client_host Clickmeetings.config.privatelabel_host
      set_client_api_key Clickmeetings.config.privatelabel_api_key

      attr_accessor :id, :account_manager_email, :email, :phone,
                    :account_manager_name, :account_manager_phone,
                    :name, :packages

      class << self
        delegate :get, to: :new
      end

      def get
        response = Clickmeetings.with_client(client_options) do
          Clickmeetings.client.get('client')
        end
        handle_response response
      end
    end
  end
end
