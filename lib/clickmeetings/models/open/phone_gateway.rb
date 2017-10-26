module Clickmeetings
  module Open
    class PhoneGateway < Model
      set_resource_name 'phone_gateways'

      attr_accessor :code, :location, :value, :geo
    end
  end
end
