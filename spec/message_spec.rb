require 'spec_helper'
require 'message'

describe Message do
  let(:data) { 'somekindadata' }
  let(:message) { Message.new(data) }

  it 'instantiates' do
    expect(message).to be_a(Message)
  end
end
