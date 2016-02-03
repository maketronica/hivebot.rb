require 'rubyserial'
require 'net/http'
require 'yaml'

class Hivebot
  attr_reader :serializer, :message_constructor, :transmission_constructor

  def initialize(serializer: Serial,
                 message_constructor: Message,
                 transmission_constructor: Transmission)
    @serializer = serializer
    @message_constructor = message_constructor
    @transmission_constructor = transmission_constructor
  end

  def run
    loop { process_next_message }
  end

  private

  def process_next_message
    next_message = get_next_message
    if next_message.valid?
      transmission_constructor.new(next_message).call
    end
  end

  def get_next_message
    message_constructor.new(next_data)
  end

  def next_data
    String.new.tap do |full_data|
      data = port.read(1000);
      until(data == '')
        full_data << data
        data = port.read(1000);
      end
    end
  end

  def port
    @port ||= serializer.new(serial_path, 115200)
  end

  def serial_path
    Dir['/dev/serial/by-id/usb-Arduino*'].first
  end
end