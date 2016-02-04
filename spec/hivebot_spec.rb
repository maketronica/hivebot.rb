require 'spec_helper'
require 'hivebot'

describe Hivebot do
  let(:data) { 'somekindadata' }
  let(:serial_connection) { double('Serial') }
  let(:serializer) do
    double('Serial', new: serial_connection)
  end
  let(:message_constructor) { double('Message') }
  let(:transmission_constructor) { double('Transmission') }
  let(:hivebot) do
    Hivebot.new(serializer: serializer,
                message_constructor: message_constructor,
                transmission_constructor: transmission_constructor)
  end

  before do
    allow(serial_connection).to receive(:read).and_return(data, '')
    allow(Dir).to receive(:[]).and_return(['/path/to/serial/device'])
  end

  describe '#run' do
    let(:message) { double('message', valid?: true) }
    let(:transmission) { double('transmission') }
    before do
      allow(hivebot).to receive(:loop).and_yield
      allow(message_constructor)
        .to receive(:new)
        .with(data)
        .and_return(message)
      allow(transmission_constructor)
        .to receive(:new)
        .with(message)
        .and_return(transmission)
      allow(transmission).to receive(:call)
    end

    it 'creates a message' do
      expect(message_constructor)
        .to receive(:new)
        .with(data)
        .and_return(message)
      hivebot.run
    end

    context 'when the data comes in very slowly' do
      before do
        allow(serial_connection)
          .to receive(:read)
          .and_return(*data.chars << '')
      end

      it 'creates a message' do
        expect(serial_connection).to receive(:read).exactly(data.length + 1)
        expect(message_constructor).to receive(:new).with(data)
        hivebot.run
      end
    end

    context 'when the message is valid' do
      it 'transmits the message' do
        expect(transmission).to receive(:call)
        hivebot.run
      end
    end

    context 'when the message is invalid' do
      let(:message) { double('message', valid?: false) }
      it 'does not transmit the message' do
        expect(transmission).not_to receive(:call)
        hivebot.run
      end
    end
  end
end
