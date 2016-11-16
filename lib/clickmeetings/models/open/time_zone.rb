module Clickmeetings
  module Open
    class TimeZone < Model
      set_resource_name 'time_zone_list'

      class << self
        def all(country: nil)
          Clickmeetings.with_client(client_options) do
            Clickmeetings.client.get remote_url(country), default_params, default_headers
          end
        end
      end
    end
  end
end
