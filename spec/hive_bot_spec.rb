describe HiveBot do
  describe '.config' do
    before do
      HiveBot.config.test = 'foo'
    end

    it 'returns previously set settings' do
      expect(HiveBot.config.test).to eq('foo')
    end
  end
end
