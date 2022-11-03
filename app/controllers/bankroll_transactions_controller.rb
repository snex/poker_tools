class BankrollTransactionsController < AuthorizedPagesController
  def index
    @poker_sessions = PokerSession.all
    @amount_won = @poker_sessions.sum('cashout - buyin')
    @bankroll_transactions = BankrollTransaction.order(date: :desc)
    @num_transactions = @bankroll_transactions.count
    @total_amount = @bankroll_transactions.sum(:amount) + @amount_won
  end
end
