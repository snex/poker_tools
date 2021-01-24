class Stake < ApplicationRecord
  scope :ordered, -> do
    select("stakes.*, array_to_string(array_agg(lpad(stakes_array, 10, '0') order by cast(stakes_array as int) desc), '') padded").
    joins(", lateral unnest(string_to_array(stake, '/')) as stakes_array").
    group(:id, :stake).
    order('padded')
  end

  def to_s
    stake
  end

  def self.cached
    @@cached ||= Stake.pluck(:stake).map { |s| { value: s, label: s } }.to_json
  end
end
