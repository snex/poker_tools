# frozen_string_literal: true

module ApplicationHelper
  def bg_color_by_result(result)
    if result.to_i.negative?
      'alert alert-danger'
    elsif result.to_i.positive?
      'alert alert-success'
    else
      'alert'
    end
  end
end
