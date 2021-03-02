class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @bingo_cards = BingoCard.where(user_id: current_user.id)
    @groups = Group.where(user: current_user)
  end
end
