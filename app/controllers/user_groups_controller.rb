class UserGroupsController < ApplicationController
  before_action :set_group, only: :create

  def create
    @user_group = UserGroup.new(user_group_params)
    @user_group.group = @group
    authorize @user_group
    if @user_group.save
      redirect_to_group_path(@group)
    else
      render 'groups/show'
    end
  end

  private

  def user_group_params
    params.require(:user_group).permit(:user_id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
