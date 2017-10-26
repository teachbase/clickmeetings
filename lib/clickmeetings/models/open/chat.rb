module Clickmeetings
  module Open
    class Chat < Model
      attr_accessor :name, :time_zone, :date, :time, :download_link

      class << self
        def find(id)
          response = Clickmeetings.with_client(client_options) do
            Clickmeetings.client.connect.get remote_url(__method__, id: id) do |req|
              req.headers.merge! default_headers
            end
          end

          response.body
        end
      end
    end
  end
end
