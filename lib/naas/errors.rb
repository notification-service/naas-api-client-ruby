module Naas
  module Errors
    JSONParseError       = Class.new(StandardError)
    RecordNotFoundError  = Class.new(StandardError)
    LinkNotFoundError    = Class.new(StandardError)
    InvalidRequestError  = Class.new(StandardError)
    InvalidArgumentError = Class.new(StandardError)
    InvalidFileError     = Class.new(StandardError)
    InvalidFilePathError = Class.new(StandardError)
    InvalidMimeTypeError = Class.new(StandardError)
  end
end
