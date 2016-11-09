module Clickmeetings
  module PrivateLabel
    class Account < ::Clickmeetings::PrivateLabel::Model
      attr_accessor :account_expiration_date,
                    :meetings_allowed,
                    :package,
                    :trainings_allowed,
                    :account_status,
                    :api_key,
                    :city,
                    :country,
                    :email,
                    :firstname,
                    :lastname,
                    :state,
                    :street,
                    :zip_code,
                    :username,
                    :webinars_allowed

      %w(enable disable).each do |m|
        define_method m do
          Clickmeetings.with_client(client_options) { client.put(remote_url(__method__, id: id)) }
          @account_status = (m == "enable" ? "active" : "disabled")
          self
        end
      end

      def conferences
        Clickmeetings::PrivateLabel::Conference.by_account(account_id: id).all
      end
    end
  end
end
