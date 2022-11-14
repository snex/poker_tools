class TableSize < ApplicationRecord
  TABLE_SIZE_ORDER = ['10/9/8 handed', '7 handed', '6 handed', '5 handed', '4 handed', '3 handed']

  validates_uniqueness_of :table_size, :description

  def to_s
    self.description
  end

  def self.cached
    @@cached ||= TableSize.pluck(:description).map { |d| { value: d, label: d } }.to_json
  end
end
