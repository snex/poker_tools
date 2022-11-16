class TableSize < ApplicationRecord
  TABLE_SIZE_ORDER = ['10/9/8 handed', '7 handed', '6 handed', '5 handed', '4 handed', '3 handed', 'Heads Up']

  validates_uniqueness_of :table_size, :description

  scope :custom_order, -> do
    order(TABLE_SIZE_ORDER.to_custom_sql_order(:description))
  end

  def to_s
    self.description
  end

  def self.cached
    @@cached ||= TableSize.custom_order.pluck(:id, :description)
  end
end
