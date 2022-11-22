# frozen_string_literal: true

class TableSize < ApplicationRecord
  TABLE_SIZE_ORDER = ['10/9/8 handed', '7 handed', '6 handed', '5 handed', '4 handed', '3 handed', 'Heads Up'].freeze

  validates :table_size, :description, uniqueness: true

  scope :custom_order, -> { order(TABLE_SIZE_ORDER.to_custom_sql_order(:description)) }

  def to_s
    description
  end

  def self.cached
    @cached ||= TableSize.custom_order.pluck(:id, :description)
  end
end
