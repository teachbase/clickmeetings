module Clickmeetings
  module Open
    class Session < Model
      include WithConference
      include WithLocale

      attr_accessor :total_visitors, :max_vistors, :start_date, :end_date, :attendees, :pdf,
                    :associations_api_key
      delegate :locale, :with_locale, :find, to: :class

      class << self
        def find(id)
          obj = super
          obj.id = id
          obj
        end
      end

      def attendees
        self.class.with_account account_api_key: associations_api_key do
          Clickmeetings.with_client(client_options) do
            Clickmeetings.client.get remote_url(__method__, id: id), default_params, default_headers
          end
        end
      end

      def generate_pdf(lang = nil)
        self.class.with_account account_api_key: associations_api_key do
          with_locale lang do
            Clickmeetings.with_client(client_options) do
              Clickmeetings.client.get remote_url("generate-pdf/#{locale}", id: id),
                default_params, default_headers
            end
          end
        end
      end

      def get_report(lang = nil)
        gen_pdf_response = generate_pdf(lang)
        return unless gen_pdf_response["status"] == "FINISHED"
        gen_pdf_response["url"] # solve this
      end

      def registrations
        self.class.with_account account_api_key: associations_api_key do
          response = Clickmeetings.with_client(client_options) do
            Clickmeetings.client.get remote_url(__method__, id: id), default_params, default_headers
          end
          Registration.by_conference(conference_id: conference_id) do
            Registration.handle_response response
          end
        end
      end
    end
  end
end
