require 'spec_helper'
require 'hivebot'

describe Hivebot do
  let(:hivebot) { Hivebot.new }

  it 'has a serial path' do
    expect(Hivebot::ARDUINO_SERIAL_PATH).to be_a(String)
  end
end
