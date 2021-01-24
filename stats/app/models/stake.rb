class Stake < ApplicationRecord
  scope :ordered, -> do
    order(Arel.sql("CAST(SPLIT_PART(stake, '/', ARRAY_LENGTH(STRING_TO_ARRAY(stake, '/'), 1)) AS int) DESC"))
  end

  def to_s
    stake
  end

  def self.cached
    @@cached ||= Stake.pluck(:stake).map { |s| { value: s, label: s } }.to_json
  end
end
