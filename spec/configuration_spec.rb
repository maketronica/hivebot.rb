require 'spec_helper'
require 'configuration'

describe Configuration do
  let(:file_reader) { double('File') }
  let(:yaml) { <<EOS }
mother:
  address: 1.2.3.4
  port: 4242
EOS

  let(:configuration) { Configuration.new(file_reader: file_reader) }

  it 'instantiates' do
    expect(configuration).to be_a(Configuration)
  end

  before do
    allow(file_reader).to receive(:read).and_return(yaml)
  end

  it 'returns moms ip address' do
    expect(configuration.address).to eq('1.2.3.4')
  end

  it 'returns moms port' do
    expect(configuration.port).to eq(4242)
  end
end
