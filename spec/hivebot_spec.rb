require 'spec_helper'
require 'hivebot'

describe Hivebot do
  let(:data) { 'somekindadata' }
  let(:serial_connection) do
    double('Serial Connection', read: data)
  end

  let(:serializer) do
    double('Serial', new: serial_connection)
  end

  let(:hivebot) { Hivebot.new(serializer: serializer) }

  it 'has a serial path' do
    expect(Hivebot::ARDUINO_SERIAL_PATH).to be_a(String)
  end

  describe '#run' do
    before do
      allow(hivebot).to receive(:loop).and_yield
      allow(serial_connection).to receive(:read).and_return(data)
    end

    it 'reads one line from the connection' do
      expect(hivebot.run).to eq(data)
    end
  end
end
