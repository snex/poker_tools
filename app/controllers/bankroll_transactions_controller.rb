# frozen_string_literal: true

class BankrollTransactionsController < AuthorizedPagesController
  def index
    @bankroll = Bankroll.new
  end
end
