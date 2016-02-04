require 'spec_helper'
require 'transmission'

describe Transmission do
  let(:address) { '1.2.3.4' }
  let(:port) { '4242' }
  let(:params) { 'foo=1&bar=2' }
  let(:message) { double('message', to_h: { foo: 1, bar: 2 }) }
  let(:http_constructor) { double('Net::HTTP') }
  let(:configuration) { double('configuration', address: address, port: port) }
  let(:transmission) do
    Transmission.new(message: message,
                     http_constructor: http_constructor,
                     configuration: configuration)
  end

  it 'instantiates' do
    expect(transmission).to be_a(Transmission)
  end

  describe '#call' do
    let(:http_client) { double('http_client') }

    before do
      allow(http_constructor)
        .to receive(:new)
        .with(address, port)
        .and_return(http_client)
    end

    it 'sends the transmission' do
      expect(http_client)
        .to receive(:send_request)
        .with('PUT', "readings/#{params}")
      transmission.call
    end
  end
end
