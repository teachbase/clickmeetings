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

    def request(method, url, &block)
      unless connect.respond_to?(method)
        fail Clickmeetings::UndefinedHTTPMethod, "method: #{method}"
      end

      handle_response(connect.send(method, url, &block))
    end

    def handle_response(response)
      case response.status
      when 200, 201
        response.body
      when 400
        fail Clickmeetings::BadRequestError, response.body
      when 401
        fail Clickmeetings::Unauthorized, response.body
      when 403
        fail Clickmeetings::Forbidden, response.body
      when 404
        fail Clickmeetings::NotFound, response.body
      when 422
        fail Clickmeetings::UnprocessedEntity, response.body
      when 500
        fail Clickmeetings::InternalServerError, response.body
      end
    end

    %w(get post put patch delete).each do |method|
      define_method method do |url, params = {}|
        l = lambda do |req|
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          req.body = params.merge(api_key: api_key).to_query
        end
        request(method, url, &l)
      end
    end
  end
end
