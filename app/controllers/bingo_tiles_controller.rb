class BingoTilesController < ApplicationController
  before_action :set_game

  def update
    @bingo_tile = BingoTile.find(params[:id])
    authorize @bingo_tile
    @bingo_tile.check
    @game.check_winners
    # BingoCardChannel.broadcast_to(
    #   @bingo_card,

    # )
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
    @bingo_card = BingoCard.find(params[:bingo_card_id])
  end
end
