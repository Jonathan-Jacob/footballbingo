class DashboardController < ApplicationController
  # skip_before_action :authenticate_user!
  def show
    @user_groups = UserGroup.where(user: current_user)
    @games = @user_groups.map do |user_group|
      user_group.group.games
    end.flatten
  end
end
