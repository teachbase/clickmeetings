module Clickmeetings
  module Open
    class Model < ::Clickmeetings::Model
      class << self
        def client_options
          { url: Clickmeetings.config.host }
        end

        def with_account(account_api_key: nil)
          Storage.cm_open_current_account = account_api_key
          if block_given?
            result = yield
            Storage.cm_open_current_account = nil
            result
          else
            self
          end
        end

        def ping
          Clickmeetings.with_client(client_options) do
            client.get "ping", default_params, default_headers
          end
        end

        def api_key
          Storage.cm_open_current_account || Clickmeetings.config.api_key
        end
      end

      delegate :api_key, to: :class

      def default_headers
        { "X-Api-Key" => api_key || Clickmeetings.config.api_key }
      end
    end
  end
end