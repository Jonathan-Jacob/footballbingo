class DashboardController < ApplicationController
  def show
    @games = Game.where(user: current_user)
    @groups = Group.where(user: current_user)
  end
end
