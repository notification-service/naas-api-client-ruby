require 'delegate'
require 'logger'

module Naas
  class Logger < SimpleDelegator
    DEFAULT_PROGNAME = "NAAS_RUBY_CLIENT"

    def initialize(name, shift_age=7, shift_size=1048576)
      @_logger = ::Logger.new(name, shift_age, shift_size)
    end

    def warn(progname = nil, &block)
      @_logger.warn((progname || DEFAULT_PROGNAME), &block)
    end

    def debug(progname = nil, &block)
      @_logger.debug((progname || DEFAULT_PROGNAME), &block)
    end

    def fatal(progname = nil, &block)
      @_logger.fatal((progname || DEFAULT_PROGNAME), &block)
    end

    def error(progname = nil, &block)
      @_logger.error((progname || DEFAULT_PROGNAME), &block)
    end

    def info(progname = nil, &block)
      @_logger.info((progname || DEFAULT_PROGNAME), &block)
    end

    def __getobj__
      @_logger
    end
  end
end
