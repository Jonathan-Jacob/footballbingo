class BingoCardsController < ApplicationController
  before_action :set_game, only: [:show, :join_game]

  def show
    @bingo_card = BingoCard.find(params[:id])
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

end
