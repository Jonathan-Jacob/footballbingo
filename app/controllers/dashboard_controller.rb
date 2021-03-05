class DashboardController < ApplicationController
  # skip_before_action :authenticate_user!
  def show
    @groups = Group.all
    @games = @groups.map do |group|
      group.games
    end.flatten
  end
end
