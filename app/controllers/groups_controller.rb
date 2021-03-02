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

  # def add_user #edit
  #   @users_group = UsersGroup.new
  #   authorize @users_group

  #   @group = Group.find(params[:id])
  #   @group.user = params[:group][:user_id]
  #   @booking.save
  #   authorize @booking
  # end

  private

  # def user_group_params
  #   params.require()
  # end

  def group_params
    params.require(:group).permit(:name, :user_id)
  end

end
