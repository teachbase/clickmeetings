module Clickmeetings
  module Open
    class Contact < Model
      attr_accessor :email, :firstname, :lastname, :phone, :company, :country

      class << self
        def create(params = {})
          super
          new(params)
        end
      end
    end
  end
end
