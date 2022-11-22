# frozen_string_literal: true

module FilterHelper
  def bet_size_filter(selected)
    select_tag(
      :bet_size,
      options_for_select(BetSize.cached.map { |id, desc| [desc, id] }.unshift([]), selected),
      { id: 'bet-size-select', class: 'form-control', 'data-placeholder': 'Filter By Bet Size', multiple: true }
    ) +
      button_tag('x', { type: 'button', id: 'reset-bet-size', class: 'form-control form-control-sm filter-button' })
  end

  def date_filter(from, to)
    text_field_tag(:from, from, { id: 'from-filter', class: 'form-control form-control-sm', placeholder: 'From' }) +
      button_tag('x', { type: 'button', id: 'reset-from', class: 'form-control form-control-sm filter-button' }) +
      text_field_tag(:to, to, { id: 'to-filter', class: 'form-control form-control-sm', placeholder: 'To' }) +
      button_tag('x', { type: 'button', id: 'reset-to', class: 'form-control form-control-sm filter-button' })
  end

  def hand_filter(selected)
    select_tag(
      :hand,
      options_for_select(Hand.cached.map { |id, hand| [hand, id] }.unshift([]), selected),
      { id: 'hand-select', class: 'form-control', 'data-placeholder': 'Filter By Hand', multiple: true }
    ) +
      button_tag('x', { type: 'button', id: 'reset-hand', class: 'form-control form-control-sm filter-button' })
  end

  def position_filter(selected)
    select_tag(
      :position,
      options_for_select(Position.cached.map { |id, position| [position, id] }.unshift([]), selected),
      { id: 'position-select', class: 'form-control', 'data-placeholder': 'Filter By Position', multiple: true }
    ) +
      button_tag('x', { type: 'button', id: 'reset-position', class: 'form-control form-control-sm filter-button' })
  end

  def stake_filter(selected)
    select_tag(
      :stake,
      options_for_select(Stake.cached.map { |id, stake| [stake, id] }.unshift([]), selected),
      { id: 'stake-select', class: 'form-control', 'data-placeholder': 'Filter By Stake', multiple: true }
    ) +
      button_tag('x', { type: 'button', id: 'reset-stake', class: 'form-control form-control-sm filter-button' })
  end

  def table_size_filter(selected)
    select_tag(
      :table_size,
      options_for_select(TableSize.cached.map { |id, desc| [desc, id] }.unshift([]), selected),
      { id: 'table-size-select', class: 'form-control', 'data-placeholder': 'Filter By Table Size', multiple: true }
    ) +
      button_tag('x', { type: 'button', id: 'reset-table-size', class: 'form-control form-control-sm filter-button' })
  end

  def advanced_filters(flop, turn, river, showdown, all_in)
    flop_filter(flop) +
      turn_filter(turn) +
      river_filter(river) +
      showdown_filter(showdown) +
      all_in_filter(all_in)
  end

  private

  def flop_filter(flop)
    select_tag(
      :flop,
      options_for_select([nil, true, false], flop),
      { id: 'flop-select', class: 'form-control', 'data-placeholder': 'Saw Flop?' }
    ) +
      button_tag('x', { type: 'button', id: 'reset-flop', class: 'form-control form-control-sm filter-button' })
  end

  def turn_filter(turn)
    select_tag(
      :turn,
      options_for_select([nil, true, false], turn),
      { id: 'turn-select', class: 'form-control', 'data-placeholder': 'Saw Turn?' }
    ) +
      button_tag('x', { type: 'button', id: 'reset-turn', class: 'form-control form-control-sm filter-button' })
  end

  def river_filter(river)
    select_tag(
      :river,
      options_for_select([nil, true, false], river),
      { id: 'river-select', class: 'form-control', 'data-placeholder': 'Saw River?' }
    ) +
      button_tag('x', { type: 'button', id: 'reset-river', class: 'form-control form-control-sm filter-button' })
  end

  def showdown_filter(showdown)
    select_tag(
      :showdown,
      options_for_select([nil, true, false], showdown),
      { id: 'showdown-select', class: 'form-control', 'data-placeholder': 'Went To Showdown?' }
    ) +
      button_tag('x', { type: 'button', id: 'reset-showdown', class: 'form-control form-control-sm filter-button' })
  end

  def all_in_filter(all_in)
    select_tag(
      :all_in,
      options_for_select([nil, true, false], all_in),
      { id: 'all-in-select', class: 'form-control', 'data-placeholder': 'All In?' }
    ) +
      button_tag('x', { type: 'button', id: 'reset-all-in', class: 'form-control form-control-sm filter-button' })
  end
end
