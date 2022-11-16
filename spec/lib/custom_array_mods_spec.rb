# frozen_string_literal: true

RSpec.describe CustomArrayMods do
  describe '#average' do
    it 'calculates the average of an array and returns it as a float' do
      expect([1, 2].average).to eq(1.5)
    end
  end

  describe '#cum_sum' do
    it 'returns a new array with the cumulate sum of the passed in array' do
      expect([1, 2, 3, 4].cum_sum).to eq([1, 3, 6, 10])
    end
  end

  describe '#longest_streak' do
    it 'returns the size of the longest streak of array elements where consecutive elements match the comparitor using the operator' do
      expect([1, 2, 2, 3].longest_streak(2, :==)).to eq(2)
      expect([1, 2, 3, -1, 4, 5].longest_streak(0, :>)).to eq(3)
    end
  end

  describe '#custom_sql_order' do
    it 'returns a SQL ORDER clause to sort the table on the supplied column by the elements in the array' do
      expect(['some', 'arbitrary', 'order'].to_custom_sql_order(:description)).to eq("CASE WHEN description = 'some' THEN 0 WHEN description = 'arbitrary' THEN 1 WHEN description = 'order' THEN 2 END")
    end
  end
end
