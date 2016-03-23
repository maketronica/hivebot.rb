require 'spec_helper'

module HiveBot
  describe MultiLogger do
    let(:logger1) { double('logger1') }
    let(:logger2) { double('logger2') }
    let(:logger) { MultiLogger.new(logger1, logger2) }

    it 'instantiates' do
      expect(logger).to be_a(MultiLogger)
    end

    describe '.error' do
      before do
        allow(logger1).to receive(:error)
        allow(logger2).to receive(:error)
      end

      it 'sends message to logger1' do
        expect(logger1).to receive(:error).with('foo')
        logger.error('foo')
      end

      it 'sends message to logger2' do
        expect(logger2).to receive(:error).with('foo')
        logger.error('foo')
      end

      context 'with a block' do
        before do
          @block = proc { 'bar' }
        end

        it 'sends message to logger1' do
          expect(logger1).to receive(:error).with('foo', &@block)
          logger.error('foo', &@block)
        end

        it 'sends message to logger2' do
          expect(logger2).to receive(:error).with('foo', &@block)
          logger.error('foo', &@block)
        end
      end
    end
  end
end
