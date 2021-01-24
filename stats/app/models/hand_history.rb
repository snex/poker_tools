class HandHistory < ApplicationRecord
  belongs_to :hand
  belongs_to :position
  belongs_to :bet_size
  belongs_to :table_size
  belongs_to :stake
end
