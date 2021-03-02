class GamesController < ApplicationController

  def index
    @games = policy_scope(Game)
  end

  # all group games / all user names

  def show
    @game = Game.find(params[:id])
    authorize @game
  end

  def new
    @game = Game.new
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    authorize @game
    if @game.save
      redirect_to game_path(@game)
    else
      render 'new'
    end
  # connection to group
  end

  def join_game
    # edit
    @game = Game.find(params[:id])
    @game
    @game.save
    authorize @game
    redirect_to game_path(@game)
  end
end

 private

  def game_params
    params.require(:game).permit(:match_id, group_id )
  end
