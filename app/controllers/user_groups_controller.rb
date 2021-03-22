class UserGroupsController < ApplicationController
  before_action :set_group
  before_action :set_user

  def index
    policy_scope(UserGroup)
    redirect_to group_path(@group)
  end

  def create
    @user_group = UserGroup.new(user: @user, group: @group)
    authorize @user_group
    if @user_group.save
      redirect_to members_group_path(@group, anchor: "member-#{@group.user.id}")
    else
      @message = Message.new
      render 'groups/members'
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
