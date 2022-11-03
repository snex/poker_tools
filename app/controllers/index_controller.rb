class IndexController < AuthorizedPagesController
  def index
    @hands = Hand.all
  end
end
