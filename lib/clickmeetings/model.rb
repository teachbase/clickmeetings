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

      delegate :remote_url, :remote_path, :handle_response, :client,
               :default_params, :default_headers, to: :new
      delegate :first, :last, to: :all
    
      def resource_name
        @resource_name ||= self.name.demodulize.pluralize.downcase
      end

      def find(id)
        response = Clickmeetings.with_client(client_options) do
          client.get(remote_url(__method__, id: id), default_params, default_headers)
        end
        handle_response(response)
      end

      def all
        response = Clickmeetings.with_client(client_options) do
          client.get(remote_url(__method__), default_params, default_headers)
        end
        handle_response(response)
      end

      def create(params = {})
        response = Clickmeetings.with_client(client_options) do
          client.post(remote_url(__method__), params.merge(default_params), default_headers)
        end
        handle_response(response)
      end

      def set_resource_name(name)
        @resource_name = name
      end

      def client_options
        { url: Clickmeetings.config.host }
      end
    end

    delegate :resource_name, to: :class
    delegate :client_options, to: :class

    def client
      Clickmeetings.client
    end

    def remote_url(action = nil, params = {})
      remote_path(action, params)
    end

    def update(params = {})
      response = Clickmeetings.with_client(client_options) do
        client.put(remote_url(__method__), params.merge(default_params), default_headers)
      end
      handle_response response
    end

    def destroy()
      Clickmeetings.with_client(client_options) do
        client.delete(remote_url(__method__), default_params, default_headers)
      end
      self
    end

    def handle_response(body)
      return unless [Hash, Array].include? body.class
      result = merge_attributes(body)
      if respond_to?("api_key") && result.respond_to?("associations_api_key=")
        result.associations_api_key = api_key
      end
      result
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
      when :destroy_all
        resource_name
      else
        "#{resource_name}/#{params[:id]}/#{action}"
      end
    end

    def default_params
      Hash.new
    end

    def default_headers
      Hash.new
    end

    private

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
        if respond_to?("#{attribute}=")
          send("#{attribute}=", val)
        elsif val.is_a? Hash
          merge_object val
        end
      end
      self
    end
  end
end
