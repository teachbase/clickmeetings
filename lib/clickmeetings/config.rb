require 'anyway'

module Clickmeetings
  class Config < Anyway::Config
    attr_config host: 'https://api.clickmeeting.com',
                api_key: 'test_key'
  end
end