module ApplicationHelper
  def bg_color_by_result(result)
    case
    when result.to_i < 0
      'alert alert-danger'
    when result.to_i > 0
      'alert alert-success'
    else
      'alert'
    end
  end

  def hand_filter(hands, selected)
    select_tag(:hand,
               options_for_select(hands.map { |h| [h.hand, h.id] }.unshift([]), selected),
               {id: 'hand-select', 'class': 'form-control', 'data-placeholder': 'Filter By Hand', multiple: true}
              ) +
              button_tag('x', {type: 'button', id: 'reset-hand', class: 'form-control form-control-sm filter-button'})
  end

  def position_filter(positions, selected)
    select_tag(:position,
               options_for_select(positions.map { |p| [p.position, p.id] }.unshift([]), selected),
               {id: 'position-select', 'class': 'form-control', 'data-placeholder': 'Filter By Position', multiple: true}
              ) +
              button_tag('x', {type: 'button', id: 'reset-position', class: 'form-control form-control-sm filter-button'})
  end

  def bet_size_filter(bet_sizes, selected)
    select_tag(:bet_size,
               options_for_select(bet_sizes.map { |b| [b.description, b.id] }.unshift([]), selected),
               {id: 'bet-size-select', 'class': 'form-control', 'data-placeholder': 'Filter By Bet Size', multiple: true}
              ) +
              button_tag('x', {type: 'button', id: 'reset-bet-size', class: 'form-control form-control-sm filter-button'})
  end

  def table_size_filter(table_sizes, selected)
    select_tag(:table_size,
               options_for_select(table_sizes.map { |t| [t.description, t.id] }.unshift([]), selected),
               {id: 'table-size-select', 'class': 'form-control', 'data-placeholder': 'Filter By Table Size', multiple: true}
              ) +
              button_tag('x', {type: 'button', id: 'reset-table-size', class: 'form-control form-control-sm filter-button'})
  end

  def stake_filter(stakes, selected)
    select_tag(:stake,
               options_for_select(stakes.map { |t| [t.stake, t.id] }.unshift([]), selected),
               {id: 'stake-select', 'class': 'form-control', 'data-placeholder': 'Filter By Stake', multiple: true}
              ) +
              button_tag('x', {type: 'button', id: 'reset-stake', class: 'form-control form-control-sm filter-button'})
  end

  def date_filter(from, to)
    text_field_tag(:from, params[:from], {id: 'from-filter', class:'form-control form-control-sm', placeholder: 'From'}) +
      button_tag('x', {type: 'button', id: 'reset-from', class: 'form-control form-control-sm filter-button'}) +
      text_field_tag(:to, params[:to], {id: 'to-filter', class: 'form-control form-control-sm', placeholder: 'To'}) +
      button_tag('x', {type: 'button', id: 'reset-to', class: 'form-control form-control-sm filter-button'})
  end

  def advanced_filters(flop, turn, river, showdown, all_in)
    select_tag(:flop,
               options_for_select([nil, true, false], flop),
               {id: 'flop-select', 'class': 'form-control', 'data-placeholder': 'Saw Flop?'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-flop', class: 'form-control form-control-sm filter-button'}) +
    select_tag(:turn,
               options_for_select([nil, true, false], turn),
               {id: 'turn-select', 'class': 'form-control', 'data-placeholder': 'Saw Turn?'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-turn', class: 'form-control form-control-sm filter-button'}) +
    select_tag(:river,
               options_for_select([nil, true, false], river),
               {id: 'river-select', 'class': 'form-control', 'data-placeholder': 'Saw River?'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-river', class: 'form-control form-control-sm filter-button'}) +
    select_tag(:showdown,
               options_for_select([nil, true, false], showdown),
               {id: 'showdown-select', 'class': 'form-control', 'data-placeholder': 'Went To Showdown?'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-showdown', class: 'form-control form-control-sm filter-button'}) +
    select_tag(:all_in,
               options_for_select([nil, true, false], all_in),
               {id: 'all-in-select', 'class': 'form-control', 'data-placeholder': 'All In?'}
              ) +
              button_tag('x', {type: 'button', id: 'reset-all-in', class: 'form-control form-control-sm filter-button'})
  end
end
