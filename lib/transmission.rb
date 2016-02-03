class Transmission
  attr_reader :message, :http_constructor, :configuration

  def initialize(message: message,
                 http_constructor: Net::HTTP,
                 configuration: Configuration.new)
    @message = message
    @http_constructor = http_constructor
    @configuration = configuration
  end

  def call
    http_client.send_request('PUT', "readings/#{encoded_params}")
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
