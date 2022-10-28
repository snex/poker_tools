module Filter
  include ActiveSupport::Concern

  def apply_filters(relation)
    if params[:bet_size].present?
      relation = relation.where(bet_size: params[:bet_size])
    end
    if params[:hand].present?
      relation = relation.where(hand: params[:hand])
    end
    if params[:position].present?
      relation = relation.where(position: params[:position])
    end
    if params[:table_size].present?
      relation = relation.where(table_size: params[:table_size])
    end
    if params[:stake].present?
      relation = relation.where(poker_sessions: { stake: params[:stake] })
    end
    if params[:from].present? && params[:to].present?
      relation = relation.where(poker_sessions: { start_time: params[:from]..params[:to] })
    elsif params[:from].present?
      relation = relation.where('poker_sessions.start_time >= ?', params[:from])
    elsif params[:to].present?
      relation = relation.where('poker_sessions.start_time <= ?', params[:to])
    end
    if params[:flop].present?
      if ActiveModel::Type::Boolean.new.cast(params[:flop])
        relation = relation.where.not(flop: nil)
      else
        relation = relation.where(flop: nil)
      end
    end
    if params[:turn].present?
      if ActiveModel::Type::Boolean.new.cast(params[:turn])
        relation = relation.where.not(turn: nil)
      else
        relation = relation.where(turn: nil)
      end
    end
    if params[:river].present?
      if ActiveModel::Type::Boolean.new.cast(params[:river])
        relation = relation.where.not(river: nil)
      else
        relation = relation.where(river: nil)
      end
    end
    if params[:showdown].present?
      relation = relation.where(showdown: ActiveModel::Type::Boolean.new.cast(params[:showdown]))
    end
    if params[:all_in].present?
      relation = relation.where(all_in: ActiveModel::Type::Boolean.new.cast(params[:all_in]))
    end

    relation
  end
end
