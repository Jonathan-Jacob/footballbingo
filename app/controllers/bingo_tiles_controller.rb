class BingoTilesController < ApplicationController
  before_action :set_game

  def update
    @bingo_tile = BingoTile.find(params[:id])
    authorize @bingo_tile
    @bingo_tile.update
    @game.check_winners
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end
