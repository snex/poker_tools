# frozen_string_literal: true

module DataAggregator
  extend ActiveSupport::Concern

  def generate_data(join, group_by)
    hh = HandHistory.
      includes(:hand, :position, :bet_size, :table_size, poker_session: :stake).
      joins(join).
      custom_filter(params).
      group(group_by)

    sums = hh.sum(:result)
    counts = hh.count(:id)
    pct_w = hh.won.count.each_with_object({}) do |(obj, count), h|
      h[obj] = (100 * count.to_f / counts[obj].to_f).round(2)
    end
    avgs = hh.average(:result).transform_values { |v| v.round(2) }
    @hh_data = {
      sums:   sums,
      counts: counts,
      pct_w:  pct_w,
      avgs:   avgs
    }
  end
end
