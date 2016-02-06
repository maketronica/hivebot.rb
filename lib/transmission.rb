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
    http_client.request_put('/', encoded_params)
  rescue Errno::EHOSTUNREACH, Errno::ECONNREFUSED
    wait_time = Time.now - @start_time
    return false if wait_time > 30
    sleep wait_time
    call
  end

  private

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
