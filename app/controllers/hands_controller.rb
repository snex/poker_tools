class HandsController < AuthorizedPagesController
  include Filter

  skip_before_action :verify_authenticity_token

  def index
    @hands = HandHistory.includes(:hand, :position, :bet_size, :table_size, poker_session: :stake).joins(:hand, poker_session: :stake).group(:'hands.hand')
    @hands = apply_filters(@hands)

    @sums = @hands.sum(:result)
    @counts = @hands.count(:id)
    @pct_w = @hands.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @hands.average(:result)
    @positions = Position.all
    @bet_sizes = BetSize.all
    @table_sizes = TableSize.all
    @stakes = Stake.all.order(:stakes_array)
  end

end
