class Configuration
  attr_reader :file_reader, :yaml_parser

  def initialize(file_reader: File, yaml_parser: YAML)
    @file_reader = file_reader
    @yaml_parser = yaml_parser
  end

  def address
    settings['mother']['address']
  end

  def port
    settings['mother']['port']
  end

  private

  def settings
    @settings ||= yaml_parser.load(file_reader.read("settings.yml"))
  end
end
