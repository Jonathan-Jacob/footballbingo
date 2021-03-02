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
    @bingo_card = BingoCard.new(user: current_user, game: @game)
    authorize @game
    authorize @bingo_card
    if @game.save && @bingo_card.save
      redirect_to game_path(@game)
    else
      render 'new'
    end
  # connection to group
  end

  def join_game
    # edit
    @bingo_card = BingoCard.new(bingo_card_params)
    authorize @bingo_card
    if @bingo_card.save
      redirect_to game_path(@game)
    else
      render 'new'
    end
  end

  private

  def game_params
    params.require(:game).permit(:match_id, :group_id)
  end

  def bingo_card_params
    params.require(:bingo_card).permit(:user_id, :game_id)
  end
end
