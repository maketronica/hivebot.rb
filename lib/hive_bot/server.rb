module HiveBot
  class Server
    attr_reader :serializer, :message_constructor, :transmission_constructor

    def initialize(serializer: Serial,
                   message_constructor: Message,
                   transmission_constructor: Transmission)
      @serializer = serializer
      @message_constructor = message_constructor
      @transmission_constructor = transmission_constructor
    end

    def run
      loop do
        process_next_message
        sleep 1
      end
    end

    private

    def process_next_message
      next_message = fetch_next_message!
      if next_message.valid?
        transmission_constructor.new(message: next_message).call
      end
    end

    def fetch_next_message!
      data = next_data
      unless data == ''
        HiveBot.logger.info(self.class) { "Received Data: #{data}" }
      end
      message_constructor.new(data)
    end

    def next_data
      ''.tap do |data|
        data << port.read(100)
        start = Time.now
        data << port.read(100) until stop_reading?(data, start)
      end
    end

    def stop_reading?(data, start)
      data == '' ||
        message_constructor.new(data).valid? ||
        (Time.now - start) >= 5
    end

    def port
      @port ||= connect_to_serial_port
    end

    def connect_to_serial_port
      until serial_path
        HiveBot.logger.error('No serial path available')
        sleep 60
      end
      HiveBot.logger.info("Connecting to serial port: #{serial_path}")
      serializer.new(serial_path, 115_200)
    end

    def serial_path
      Dir['/dev/serial/by-id/usb-Arduino*'].first
    end
  end
end
