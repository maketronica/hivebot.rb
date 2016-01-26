require 'rubyserial'

class Hivebot
  ARDUINO_SERIAL_PATH = Dir['/dev/serial/by-id/usb-Arduino*'].first

  def run
    while(true) do
      data = port.read(1000);
      puts data unless data.empty?
    end
  end

  private

  def port
    @port ||= Serial.new(ARDUINO_SERIAL_PATH, 115200)
  end
end

Hivebot.new.run
