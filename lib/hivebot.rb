require 'rubyserial'

class Hivebot
  attr_reader :serializer, :message_constructor

  def initialize(serializer: Serial, message_constructor: Message)
    @serializer = serializer
    @message_constructor = message_constructor
  end

  def run
    loop { read }
  end

  private

  def read
    full_data = ''
    data = port.read(1000);
    until(data == '')
      full_data << data
      data = port.read(1000);
    end
    message_constructor.new(full_data)
  end

  def port
    @port ||= serializer.new(serial_path, 115200)
  end

  def serial_path
    Dir['/dev/serial/by-id/usb-Arduino*'].first
  end
end
