module HiveBot
  class Transmission
    attr_reader :message, :http_constructor

    def initialize(message:,
                   http_constructor: Net::HTTP)
      @message = message
      @http_constructor = http_constructor
    end

    def call
      @start_time ||= Time.now
      HiveBot.logger.info(self.class) { "Sending: #{message.to_h}" }
      http_client.request_put('/', encoded_params)
    rescue Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ENETUNREACH,
           Errno::EINVAL, Errno::ETIMEDOUT, Net::ReadTimeout => e
      log_error("Error Sending: #{e} : #{e.class} :#{e.message}")
      wait_and_try_again
    end

    private

    def wait_and_try_again
      return false if wait_time > 30
      log_error("Trying again in: #{wait_time} seconds")
      sleep wait_time
      call
    end

    def wait_time
      Time.now - @start_time
    end

    def http_client
      http_constructor.new(
        HiveBot.config.hivemom[:address],
        HiveBot.config.hivemom[:port]
      )
    end

    def encoded_params
      URI.encode_www_form(message.to_h)
    end

    def log_error(text)
      HiveBot.logger.error(self.class) { text }
    end
  end
end
