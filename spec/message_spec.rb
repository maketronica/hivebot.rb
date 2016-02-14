require 'spec_helper'

describe Message do
  let(:data) { 'B|foo=1&bar=2&baz=3%79|E' }
  let(:message) { Message.new(data) }

  it 'instantiates' do
    expect(message).to be_a(Message)
  end

  describe '#to_h' do
    it 'returns a correct hash' do
      expect(message.to_h).to eq('foo' => '1', 'bar' => '2', 'baz' => '3')
    end
  end

  describe '#valid?' do
    context 'when it has a valid checksum' do
      it 'is truthy' do
        expect(message.valid?).to be_truthy
      end
    end

    context 'when it has an invalid checksum' do
      let(:data) { 'B|foo=1&bar=2&baz=3%078|E' }
      it 'is falsey' do
        expect(message.valid?).to be_falsey
      end
    end

    context' when data is garbage' do
      let(:data) { 'iamapileofgarbage' }
      it 'is falsey' do
        expect(message.valid?).to be_falsey
      end
    end
  end
end
