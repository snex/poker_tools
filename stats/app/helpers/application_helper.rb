module ApplicationHelper
  def bg_color_by_result(result)
    case
    when result.to_i < 0
      'alert alert-danger'
    when result.to_i > 0
      'alert alert-success'
    else
      ''
    end
  end

  def hand_filter(hands, selected)
    select_tag(:hand,
               options_for_select(hands.map { |h| [h.hand, h.id] }.unshift([]), selected),
               {id: 'hand-select', 'class': 'form-control', 'data-placeholder': 'Filter By Hand'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-hand', class: 'form-control form-control-sm filter-button'})
  end

  def position_filter(positions, selected)
    select_tag(:position,
               options_for_select(positions.map { |p| [p.position, p.id] }.unshift([]), selected),
               {id: 'position-select', 'class': 'form-control', 'data-placeholder': 'Filter By Position'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-position', class: 'form-control form-control-sm filter-button'})
  end

  def bet_size_filter(bet_sizes, selected)
    select_tag(:bet_size,
               options_for_select(bet_sizes.map { |b| [b.description, b.id] }.unshift([]), selected),
               {id: 'bet-size-select', 'class': 'form-control', 'data-placeholder': 'Filter By Bet Size'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-bet-size', class: 'form-control form-control-sm filter-button'})
  end

  def table_size_filter(table_sizes, selected)
    select_tag(:table_size,
               options_for_select(table_sizes.map { |t| [t.description, t.id] }.unshift([]), selected),
               {id: 'table-size-select', 'class': 'form-control', 'data-placeholder': 'Filter By Table Size'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-table-size', class: 'form-control form-control-sm filter-button'})
  end

  def date_filter(from, to)
    text_field_tag(:from, params[:from], {id: 'from-filter', class:'form-control form-control-sm', placeholder: 'From'}) +
      button_tag('x', {type: 'button', id: 'reset-from', class: 'form-control form-control-sm filter-button'}) +
      text_field_tag(:to, params[:to], {id: 'to-filter', class: 'form-control form-control-sm', placeholder: 'To'}) +
      button_tag('x', {type: 'button', id: 'reset-to', class: 'form-control form-control-sm filter-button'})
  end
end
