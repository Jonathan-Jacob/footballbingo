class GamesController < ApplicationController
  before_action :set_game, only: [:show, :join_game]
  before_action :set_group, only: [:new, :create, :show]

  def index
    @games = policy_scope(Game)
  end

  # all group games / all user names

  def show
    @game.group = @group
    authorize @game
  end

  def new
    @game = Game.new(group: @group)
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    if @game.too_late_to_start?
      render 'new'
    else
      @game.group = @group
      authorize @game
      @bingo_card = BingoCard.new(user: current_user, game: @game)
      authorize @bingo_card
      @bingo_card.populate
      if @game.save
        redirect_to group_path(@group)
      else
        render 'new'
      end
    end
  end

  private

  def game_params
    params.require(:game).permit(:match_id)
  end

  def set_game
    @game = Game.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
