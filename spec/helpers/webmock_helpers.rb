module ClickmeetingWebMock
  def mock_api(verb = nil, action = nil, status = 200, open: false)
    host = open ? Clickmeetings.config.host : Clickmeetings.config.privatelabel_host
    params = [
      verb, host,
      action, status
    ]
    action_stub(*params) unless action.nil? || verb.nil?
  end

  def action_stub(verb, host, action, status)
    stub_request(verb, "#{host}/#{action}")
      .to_return(
        status: status,
        headers: {
          'Content-Type' => 'application/json'
        },
        body: file_read(verb, action)
      )
  end
end
