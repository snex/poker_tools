# frozen_string_literal: true

class VillainHand < ApplicationRecord
  belongs_to :hand_history
  belongs_to :hand
end
