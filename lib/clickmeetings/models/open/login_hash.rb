module Clickmeetings
  module Open
    class LoginHash < Model
      class InvalidParamsError < ::Clickmeetings::ClickmeetingError; end

      set_resource_name "room/autologin_hash"

      attr_accessor :conference_id, :nickname, :email, :token, :password, :role, :autologin_hash

      class << self
        attr_reader :conference_id

        def create(params = {})
          validate_params params
          params[:token] = params[:token].token if params[:token].is_a? Token
          @conference_id = params.delete(:conference_id)
          obj = super
          params.each do |key, value|
            obj.send("#{key}=", value)
          end
          obj
        end

        private

        def validate_params(params)
          %i(conference_id nickname email role).each do |param|
            fail InvalidParamsError, "Missing required parameter #{param}" if params[param].nil?
          end
          conf = Conference.find(params[:conference_id])
          if conf.access_type == 2 && params[:password].nil?
            fail InvalidParamsError, "Missing required parameter password"
          elsif conf.access_type == 3 && params[:token].nil?
            fail InvalidParamsError, "Missing required parameter token"
          end
        end
      end

      def initialize(params = {})
        super
        @conference_id ||= self.class.conference_id
      end

      def remote_url(action = nil, params = {})
        Conference.remote_path(:find, id: params[:conference_id] || conference_id) +
          '/' + remote_path(action, params)
      end
    end
  end
end
