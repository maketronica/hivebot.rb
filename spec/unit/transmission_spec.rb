require 'spec_helper'

module HiveBot
  describe Transmission do
    let(:address) { '1.2.3.4' }
    let(:port) { '4242' }
    let(:params) { 'foo=1&bar=2' }
    let(:message) { double('message', to_h: { foo: 1, bar: 2 }) }
    let(:http_constructor) { double('Net::HTTP') }
    let(:transmission) do
      Transmission.new(message: message,
                       http_constructor: http_constructor)
    end

    before do
      allow(HiveBot.config).to receive(:hivemom)
                           .and_return({address: address, port: port})
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
          .to receive(:request_put)
          .with('/', params)
        transmission.call
      end

      context 'there are http errors' do
        before do
          allow(transmission).to receive(:sleep) { sleep 0.01 }
        end

        context 'initially receive http errors, but eventually successfull' do
          before do
            allow(http_client).to receive(:request_put) do
              @attempts ||= 0
              @attempts += 1
              case @attempts
              when 1 then raise Errno::EHOSTUNREACH
              when 2 then raise Errno::ECONNREFUSED
              else true
              end
            end
          end

          it 'sends the transmission' do
            expect(http_client)
              .to receive(:request_put)
              .with('/', params)
              .exactly(3)
            Timecop.scale(60) do
              transmission.call
            end
          end
        end

        context 'connection fails for too long' do
          before do
            allow(http_client)
              .to receive(:request_put)
              .and_raise(Errno::EHOSTUNREACH)
          end

          it 'eventually gives up' do
            Timeout.timeout(1) do
              Timecop.scale(3600) do
                expect(transmission.call).to be_falsey
              end
            end
          end
        end
      end
    end
  end
end
