class PositionsController < AuthorizedPagesController
  include Filter

  skip_before_action :verify_authenticity_token

  def index
    @positions = HandHistory.includes(:hand, :bet_size, :table_size, poker_session: :stake).joins(:position, poker_session: :stake).group(:'positions.position')
    @positions = apply_filters(@positions)

    @sums = @positions.sum(:result)
    @counts = @positions.count(:id)
    @pct_w = @positions.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @positions.average(:result)
  end
end
