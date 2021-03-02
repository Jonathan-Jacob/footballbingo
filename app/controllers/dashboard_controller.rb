class DashboardController < ApplicationController
  def show
    @bingo_cards = BingoCard.where(user_id: current_user.id)
    @groups = Group.where(user: current_user)
  end
end
