class GroupsController < ApplicationController
  def index
    @groups = policy_scope(Group).order(name: :asc)
  end

  def show
    @group = Group.find(params[:id])
    authorize @group
    @games = @group.games
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = Group.new(group_params)
    authorize @group
    @group.user = current_user
    # user_group = UserGroup.new(group: @group, user: current_user)
    # user_group.save!
    if @group.save
      redirect_to group_path(@group)
    else
      render 'new'
    end
  end

  private

  def user_group_params
    params.require(:users_group).permit(:user_id, :group_id)
  end

  def group_params
    params.require(:group).permit(:name)
  end
end

#simple_form_for [@group, @users_group] points to users_group_id