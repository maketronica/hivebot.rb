require 'spec_helper'
require 'hivebot'

describe Hivebot do
  let(:data) { 'somekindadata' }
  let(:serial_connection) { double('Serial') }
  let(:serializer) do
    double('Serial', new: serial_connection)
  end
  let(:message_constructor) { double('Message') }
  let(:hivebot) do
    Hivebot.new(serializer: serializer,
                message_constructor: message_constructor)
  end

  before do
    allow(serial_connection).to receive(:read).and_return(data, '')
    allow(Dir).to receive(:[]).and_return(['/path/to/serial/device'])
  end

  describe '#run' do
    before do
      allow(hivebot).to receive(:loop).and_yield
      allow(message_constructor).to receive(:new).with(data)
    end

    it 'creates a message' do
      expect(message_constructor).to receive(:new).with(data)
      hivebot.run
    end

    context 'when the data comes in very slowly' do
      before do
        allow(serial_connection).to receive(:read)
                                .and_return(*(data.chars) << '')
      end

      it 'creates a message' do
        expect(serial_connection).to receive(:read).exactly(data.length+1)
        expect(message_constructor).to receive(:new).with(data)
        hivebot.run
      end
    end
  end
end
