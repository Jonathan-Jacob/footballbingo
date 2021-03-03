class DashboardController < ApplicationController
  def show
    @groups = Group.where(user: current_user)
    @games = @groups.map do |group|
      group.games
    end.flatten
  end
end
