class BingoCardsController < ApplicationController
  before_action :set_game, only: [:show, :create]

  def show
    @bingo_card = BingoCard.find(params[:id])
    authorize @bingo_card
  end

  def create
    @bingo_card = BingoCard.new
    @bingo_card.game = @game
    @bingo_card.user = current_user
    authorize @bingo_card
    if @bingo_card.save
      redirect_to game_bingo_card_path(@game, @bingo_card)
    else
      redirect_to group_game_path(@game.group, @game)
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end
