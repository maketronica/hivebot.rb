class Message
  attr_reader :data, :body, :checksum

  def initialize(data)
    @data = data
  end

  def to_h
    {}.tap do |hash|
      body.split('&').each do |pair|
        k, v = pair.split('=')
        hash[k] = v
      end
    end
  end

  def valid?
    provided_checksum.to_i == computed_checksum
  end

  private

  def computed_checksum
    body && body.bytes.reduce(:+).modulo(256)
  end

  def body
    matchdata && matchdata[1]
  end

  def provided_checksum
    matchdata && matchdata[2]
  end

  def matchdata
    @matchdata ||= data.match(/B\|(.+)\%([0-9]{1,3})\|E/)
  end
end
