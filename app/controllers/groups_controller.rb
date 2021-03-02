class GroupsController < ApplicationController
  def index
    @groups = policy_scope(Group).order(name: :asc)
  end

  def show
    @group = Group.find(params[:id])
    authorize @group
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = Group.new(group_params)
    authorize @group
    @group.user = current_user
    if @group.save
      redirect_to_group_path(@group)
    else
      render 'new'
    end
  end

  def add_user
    @users_group = UsersGroup.new(users_group_params)
    authorize @users_group
    if @users_group.save
      redirect_to_group_path(@group)
    else
      render 'new'
    end
  end

  private

  def users_group_params
    params.require(:users_group).permit(:user_id, :group_id)
  end

  def group_params
    params.require(:group).permit(:name, :user_id)
  end
end
