class IndexController < ApplicationController
  def index
    @hands = Hand.all
  end
end
