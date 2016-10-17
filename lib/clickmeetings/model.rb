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
    
      def resource_name
        @resource_name || pluralize(demodulize(self.name.to_s))
      end

      def find(id)
        response = Clickmeetings.client.get(remote_url(__method__, id: id))
        new.handle_response(response)
      end

      def all
        response = Clickmeetings.client.get(remote_url(__method__))
        new.handle_response(response)
      end
    end

    delegate :resource_name, to: :class

    def client
      Clickmeetings.client
    end

    def remote_url(action = nil, params = {})
      url = case action
            when :all
              resource_name
            when :show
              "#{resource_name}/#{params[:id]}"
            when :create
              resource_name
            when :update
              "#{resource_name}/#{id}"
            when :delete
              "#{resource_name}/#{id}"
            else
              "#{resource_name}/#{id}/#{action}"
            end
      "#{url}?api_key=#{Clickmeetings.client.api_key}"
    end

    def persist?
      !!id
    end

    def create(params = {})
      handle_response client.post(remote_url(__method__), params)
    end

    def update(params = {})
      handle_response client.put(remote_url(__method__), params)
    end

    def delete(params = {})
      handle_response client.delete(remote_url(__method__), params)
    end

    def handle_response(body)
      return unless body.present?
      merge_attributes(body)
      self
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
      attrs.each { |e| merge_object(e) }
    end

    def merge_object(attrs)
      attrs.each do |attribute, val|
        next unless respond_to?(attribute)
        send("#{attribute}=", value)
      end      
    end
  end
end
