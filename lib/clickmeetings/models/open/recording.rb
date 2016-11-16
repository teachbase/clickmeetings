module Clickmeetings
  module Open
    class Recording < Model
      include WithConference

      attr_accessor :recording_duration, :recording_file_size, :recording_started, :recording_url,
                    :recording_start_date

      class << self
        def destroy_all
          res = all

          Clickmeetings.with_client(client_options) do
            Clickmeetings.client.delete remote_url(__method__), default_headers, default_params
          end

          res
        end
      end
    end
  end
end
