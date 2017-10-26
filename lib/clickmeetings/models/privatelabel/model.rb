module Clickmeetings
  module PrivateLabel
    class Model < ::Clickmeetings::Model
      class << self
        def client_options
          { url: Clickmeetings.config.privatelabel_host }
        end
      end

      def default_params
        { api_key: Clickmeetings.config.privatelabel_api_key }
      end
    end
  end
end
