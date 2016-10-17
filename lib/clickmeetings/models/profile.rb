module Clickmeetings
  class Profile
    attr_accessor :id, :account_manager_email, :email, :phone,
                  :account_manager_name, :account_manager_phone,
                  :name, :packages

    def get
      url = "client?api_key=#{Clickmeetings.client.api_key}"
      Clickmeetings.client
    end
  end
end
