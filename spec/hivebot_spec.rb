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

  let(:message_constructor) { double('Message') }

  let(:hivebot) do
    Hivebot.new(serializer: serializer,
                message_constructor: message_constructor)
  end

  before do
    allow(Dir).to receive(:[]).and_return(['/path/to/serial/device'])
  end

  describe '#run' do
    before do
      allow(hivebot).to receive(:loop).and_yield
      allow(serial_connection).to receive(:read).and_return(data)
      allow(message_constructor).to receive(:new).with(data)
    end

    it 'creates a message' do
      expect(message_constructor).to receive(:new).with(data)
      hivebot.run
    end
  end
end
