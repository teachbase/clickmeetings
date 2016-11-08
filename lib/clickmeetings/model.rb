require 'clickmeetings'
require 'active_model'

module Clickmeetings
  class Model
    include ActiveModel::Model
    include ActiveModel::AttributeMethods
    include ActiveModel::Validations

    attr_accessor :id
  
    class << self
      attr_accessor :resource_name
      attr_reader :client_host, :client_api_key

      delegate :remote_url, :remote_path, :handle_response, :client, to: :new
    
      def resource_name
        @resource_name ||= self.name.demodulize.pluralize.downcase
      end

      def find(id)
        response = Clickmeetings.with_client(client_options) do
          client.get(remote_url(__method__, id: id))
        end
        handle_response(response)
      end

      def all
        response = Clickmeetings.with_client(client_options) do
          client.get(remote_url(__method__))
        end
        handle_response(response)
      end

      def create(params = {})
        response = Clickmeetings.with_client(client_options) do
          client.post(remote_url(__method__), params)
        end
        handle_response(response)
      end

      def set_resource_name(name)
        @resource_name = name
      end

      def set_client_host(host = nil)
        @client_host = host
      end

      def set_client_api_key(api_key = nil)
        @client_api_key = api_key
      end

      def client_options
        {
          url: @client_host ||= Clickmeetings.config.host,
          api_key: @client_api_key ||= Clickmeetings.config.api_key
        }
      end
    end

    delegate :resource_name, to: :class

    def client
      Clickmeetings.client
    end

    def remote_url(action = nil, params = {})
      url = remote_path(action, params)
    end

    def persist?
      !!id
    end

    def update(params = {})
      response = Clickmeetings.with_client(client_options) do
        client.put(remote_url(__method__), params)
      end
      handle_response response
    end

    def destroy(params = {})
      Clickmeetings.with_client(client_options) { client.delete(remote_url(__method__), params) }
      self
    end

    def handle_response(body)
      return unless [Hash, Array].include? body.class
      merge_attributes(body)
    end

    def remote_path(action = nil, params = {})
      case action
      when :all
        resource_name
      when :find
        "#{resource_name}/#{params[:id]}"
      when :create
        resource_name
      when :update
        "#{resource_name}/#{id}"
      when :destroy
        "#{resource_name}/#{id}"
      else
        "#{resource_name}/#{params[:id]}/#{action}"
      end
    end

    private

    delegate :client_options, to: :class

    def merge_attributes(attrs)
      if attrs.is_a?(Array)
        merge_collection(attrs)
      else
        merge_object(attrs)
      end
    end

    def merge_collection(attrs)
      attrs.map { |e| self.class.new.handle_response(e) }
    end

    def merge_object(attrs)
      attrs.each do |attribute, val|
        if respond_to?(attribute)
          send("#{attribute}=", val)
        elsif val.is_a? Hash
          merge_object val
        end
      end
      self
    end
  end
end
