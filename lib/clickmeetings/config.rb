require 'anyway'

module Clickmeetings
  class Config < Anyway::Config
    config_name :clickmeetings
    attr_config privatelabel_host: 'https://api.clickmeeting.com/privatelabel/v1',
                host: 'https://api.clickmeeting.com/v1',
                api_key: 'test_key',
                privatelabel_api_key: 'privatelabel_api_key'
  end
end
