class BingoTilesController < ApplicationController
  before_action :set_game

  def update
    @bingo_tile = BingoTile.find(params[:id])
    authorize @bingo_tile
    @bingo_tile.check
    @game.check_winners
    redirect_to game_bingo_card_path(@game, @bingo_tile.bingo_card)
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end
