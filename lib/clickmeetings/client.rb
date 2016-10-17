require 'faraday'
require 'faraday_middleware'
require 'json'

module Clickmeetings
  class Client
    attr_reader :url, :api_key

    def initialize(url: Clickmeetings.config.host,
                   api_key: Clickmeetings.config.api_key)

      @url = url
      @api_key = api_key

      @connect = Faraday.new(url: url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.response :json, content_type: /\bjson$/
        faraday.use :instrumentation
      end
    end

    def connect
      @connect || self.class.new
    end

    def request(method, url, params = {})
      unless connect.respond_to?(method)
        fail Clickmeetings::UndefinedHTTPMethod, "method: #{method}"
      end

      handle_response(connect.send(method, url, params))
    end

    def handle_response(response)
      case response.status
      when 200
        response.body
      when 401
        fail Clickmeetings::Unauthorized
      when 404
        fail Clickmeetings::NotFound
      when 500
        fail Clickmeetings::InternalServerError
      end
    end

    %w(get post put patch delete).each do |method|
      define_method method do |url, params|
        request(method, url, params)
      end
    end
  end
end
