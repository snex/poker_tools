# frozen_string_literal: true

class VillainHand < ApplicationRecord
  belongs_to :hand_history
  belongs_to :hand

  scope :custom_order, -> { joins(:hand).order(Hand::HAND_ORDER.to_custom_sql_order(:hand)) }
end
