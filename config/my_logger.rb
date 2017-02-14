module MyLogger
  def logger
    @logger ||= MyLogger.logger_for(self.class.name)
  end

  # Use a hash class-ivar to cache a unique Logger per class:
  @loggers = {}

  class << self
    def logger_for(classname)
      @loggers[classname] ||= configure_logger_for(classname)
    end

    def configure_logger_for(classname)
      return MyLogger.factory classname
    end
  end

  def log_exception(exception, args)
    @logger.error("Received #{exception}, class #{self.class.name} failed with #{args}")
    @logger.error exception.message
    @logger.error exception.backtrace.join("\n")
  end

  def self.factory(classname)
    layout = Logging::Layouts::Pattern.new(:pattern => LOG_FORMAT, :date_pattern => DATE_STRING)

    Logging.logger.root.appenders = (Logging.appenders.stdout :layout => layout),
        Logging.appenders.file(LOG_FILE,  :layout => layout)
    return Logging.logger[classname]
  end
end