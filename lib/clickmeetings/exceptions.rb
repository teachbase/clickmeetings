module Clickmeetings
  class ClickmeetingError < ::StandardError; end

  class Clickmeetings::BadRequestError < ClickmeetingError; end

  class Clickmeetings::UndefinedHTTPMethod < ClickmeetingError; end

  class Clickmeetings::Unauthorized < ClickmeetingError; end

  class Clickmeetings::Forbidden < ClickmeetingError; end
  
  class Clickmeetings::NotFound < ClickmeetingError; end
  
  class Clickmeetings::Invalid < ClickmeetingError; end

  class UnprocessedEntity < ClickmeetingError; end
  
  class Clickmeetings::InternalServerError < ClickmeetingError; end
end
