require 'clickmeetings/version'
require 'clickmeetings/config'
require 'clickmeetings/client'
require 'clickmeetings/model'
require 'clickmeetings/exceptions'

module Clickmeetings
  def self.config
    @config ||= Config.new
  end

  def self.properties
    client.properties
  end

  def self.configure
    yield(config) if block_given?
  end

  def self.client
    ClientRegistry.client || (@client ||= Client.new)
  end

  def self.reset
    @config = nil
    @client = nil
  end

  def self.with_client(client)
    client = Client.new(client) unless client.is_a?(Client)
    ClientRegistry.client = client
    result = yield
    ClientRegistry.client = nil
    result
  end

  class ClientRegistry # :nodoc:
    extend ActiveSupport::PerThreadRegistry

    attr_accessor :client
  end

  require 'clickmeetings/engine' if defined?(Rails)
  Gem.find_files('clickmeetings/models/open_api/*.rb').each { |f| require f }
  Gem.find_files('clickmeetings/models/privatelabel/*.rb').each { |f| require f }
end
