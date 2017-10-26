module Clickmeetings
  module Open
    class FileLibrary < Model
      set_resource_name 'file-library'

      attr_accessor :status, :url, :document_type, :conversion_progress, :status_message,
                    :name, :upload_date

      class << self
        def create(path: '', conference_id: nil)
          params = { uploaded: Faraday::UploadIO.new(path, '') }
          if conference_id.present?
            response = Clickmeetings.with_client(client_options) do
              Clickmeetings.client.post remote_url("conferences/#{conference_id}"),
                params.merge(default_params), default_headers
            end
            handle_response response
          else
            super(params)
          end
        end

        def for_conference(conference_id: nil)
          response = Clickmeetings.with_client(client_options) do
            Clickmeetings.client.get remote_url("conferences/#{conference_id}"),
              default_params, default_headers
          end
          handle_response response
        end
      end

      # returns content of file; use File#write to save it
      def download
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
