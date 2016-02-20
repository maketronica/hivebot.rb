require 'spec_helper'

module HiveBot
  describe Server do
    let(:data) { 'somekindadata!' }
    let(:serial_connection) { double('Serial') }
    let(:serializer) do
      double('Serial', new: serial_connection)
    end
    let(:message_constructor) { double('Message') }
    let(:transmission_constructor) { double('Transmission') }
    let(:hivebot) do
      Server.new(serializer: serializer,
                 message_constructor: message_constructor,
                 transmission_constructor: transmission_constructor)
    end

    before do
      allow(serial_connection).to receive(:read).and_return(data, '')
      allow(Dir).to receive(:[]).and_return(['/path/to/serial/device'])
    end

    describe '#run' do
      let(:valid_message) { double('valid message', valid?: true) }
      let(:invalid_message) { double('invalid message', valid?: false) }
      let(:transmission) { double('transmission') }

      before do
        allow(hivebot).to receive(:loop).and_yield
        allow(message_constructor)
          .to receive(:new)
          .and_return(invalid_message)
        allow(message_constructor)
          .to receive(:new)
          .with(data)
          .and_return(valid_message)
        allow(transmission_constructor)
          .to receive(:new)
          .with(message: valid_message)
          .and_return(transmission)
        allow(transmission).to receive(:call)
      end

      it 'creates a message' do
        expect(message_constructor)
          .to receive(:new)
          .with(data)
          .and_return(valid_message)
        hivebot.run
      end

      context 'when there is no data' do
        before do
          allow(serial_connection)
            .to receive(:read)
            .and_return('')
        end
        it 'gracefully waits' do
          expect(serial_connection).to receive(:read).exactly(1)
          expect(message_constructor).not_to receive(:new).with(data)
          hivebot.run
        end
      end

      context 'when the data comes in very slowly' do
        let(:slow_data) { data.chars }
        before do
          10.times { slow_data.insert(rand(1..slow_data.size), '') }
          allow(serial_connection)
            .to receive(:read)
            .and_return(*slow_data)
        end

        it 'creates a message' do
          expect(serial_connection)
            .to receive(:read)
            .exactly(slow_data.index('!') + 1)
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
        before do
          allow(message_constructor)
            .to receive(:new)
            .with(data)
            .and_return(invalid_message)
        end

        it 'does not transmit the message' do
          Timecop.scale(10) do
            expect(transmission).not_to receive(:call)
            hivebot.run
          end
        end
      end
    end
  end
end
