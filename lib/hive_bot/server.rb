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
      wait_for_serial_path
      HiveBot.logger.info("Connecting to serial port: #{serial_path}")
      begin
        serializer.new(serial_path, 115_200)
      rescue Errno::ENODEV => error
        process_serial_path_rescue(error)
      end
    end

    def wait_for_serial_path
      until serial_path
        log_error('No serial path available')
        sleep 60
      end
    end

    def process_serial_path_rescue(error)
      @enodev_counter ||= 0
      @enodev_counter += 1
      if @enodev_counter < 10
        log_error("Failed to connect to #{serial_path}. Trying again.")
        sleep 10
        connect_to_serial_port
      else
        log_error("Failed to connect to #{serial_path}. Giving up.")
        raise error
      end
    end

    def serial_path
      Dir['/dev/serial/by-id/usb-Arduino*'].first
    end

    def log_error(text)
      HiveBot.logger.error(self.class) { text }
    end
  end
end
