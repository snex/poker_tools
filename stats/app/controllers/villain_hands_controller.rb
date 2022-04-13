class VillainHandsController < ApplicationController
  include Filter

  skip_before_action :verify_authenticity_token

  def index
    @villain_hands = HandHistory.includes(:hand, :position, :bet_size, :table_size, :stake).joins(villain_hands: :hand).group(:'hands.hand')
    @villain_hands = apply_filters(@villain_hands)

    @sums = @villain_hands.sum(:result)
    @counts = @villain_hands.count(:id)
    @pct_w = @villain_hands.where('result >= 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @villain_hands.average(:result)
    @hands = Hand.all
    @positions = Position.all
    @bet_sizes = BetSize.all
    @table_sizes = TableSize.all
    @stakes = Stake.all.order(:stakes_array)
  end

end
