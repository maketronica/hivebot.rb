module HiveBot
  class Transmission
    attr_reader :message, :http_constructor, :configuration

    def initialize(message:,
                   http_constructor: Net::HTTP,
                   configuration: Configuration.new)
      @message = message
      @http_constructor = http_constructor
      @configuration = configuration
    end

    def call
      @start_time ||= Time.now
      HiveBot.logger.info(self.class) { "Sending: #{message.to_h}" }
      http_client.request_put('/', encoded_params)
    rescue Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ENETUNREACH,
             Errno::EINVAL, Net::ReadTimeout,  => e
      HiveBot.logger.error(self.class) { "Error Sending: #{e} : #{e.class} :#{e.message}" }
      wait_and_try_again
    end

    private

    def wait_and_try_again
      return false if wait_time > 30
      HiveBot.logger.error(self.class) do
        "Trying again in: #{wait_time} seconds"
      end
      sleep wait_time
      call
    end

    def wait_time
      Time.now - @start_time
    end

    def http_client
      http_constructor.new(
        configuration.address,
        configuration.port
      )
    end

    def encoded_params
      URI.encode_www_form(message.to_h)
    end
  end
end
