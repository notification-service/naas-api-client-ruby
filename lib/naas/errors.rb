module Naas
  module Errors
    JSONParseError      = Class.new(StandardError)
    RecordNotFoundError = Class.new(StandardError)
    LinkNotFoundError   = Class.new(StandardError)
    InvalidRequestError = Class.new(StandardError)
  end
end
