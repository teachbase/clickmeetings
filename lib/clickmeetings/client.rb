require 'faraday'
require 'faraday_middleware'
require 'json'

module Clickmeetings
  class Client
    attr_reader :url, :connect

    def initialize(url: Clickmeetings.config.host)
      @url = url

      @connect = Faraday.new(url: url) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.use :instrumentation
        faraday.adapter Faraday.default_adapter
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
        body = response.body
        body = JSON.parse body unless body == "true"
        body
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
      define_method method do |url, params = {}, headers = {}|
        l = lambda do |req|
          req.headers.merge! headers
          req.body = params
        end
        request(method, url, &l)
      end
    end
  end
end
