RSpec.describe CustomNumericMods do
  describe '#to_elapsed_time' do
    it 'turns an integer in seconds into an elapsed time in h:mm format' do
      expect(120.to_elapsed_time).to eq('0:02')
    end
  end
end
