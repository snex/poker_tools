# frozen_string_literal: true

class Bankroll
  attr_reader :bankroll_transactions, :poker_sessions

  def initialize
    @bankroll_transactions = BankrollTransaction.order(date: :desc)
    @poker_sessions = PokerSession.all
  end

  def total_amount
    @bankroll_transactions.sum(:amount) + @poker_sessions.results
  end
end
