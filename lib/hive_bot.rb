module HiveBot
  def self.config
    @config ||= OpenStruct.new
  end

  def self.logger
    config.logger ? multi_logger : default_logger
  end

  def self.root
    @root ||= File.expand_path('../../', __FILE__)
  end

  private_class_method

  def self.multi_logger
    @multi_logger ||= MultiLogger.new(default_logger, config.logger)
  end

  def self.default_logger
    Logger.new(default_log_file, 5, 1_024_000)
  end

  def self.default_log_file
    File.open(File.expand_path("#{root}/log/#{config.env}.log", __FILE__), 'a')
  end
end
