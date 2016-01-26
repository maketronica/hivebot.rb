require 'rubyserial'

class Hivebot
  ARDUINO_SERIAL_PATH = Dir['/dev/serial/by-id/usb-Arduino*'].first

  attr_reader :serializer

  def initialize(serializer: Serial)
    @serializer = serializer
  end

  def run
    loop { read }
  end

  private

  def read
    port.read(1000);
  end

  def port
    @port ||= serializer.new(ARDUINO_SERIAL_PATH, 115200)
  end
end
