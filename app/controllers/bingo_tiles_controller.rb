class BingoTilesController < ApplicationController
  before_action :set_game

  def update
    @bingo_tile = BingoTile.find(params[:id])
    authorize @bingo_tile
    @bingo_tile.check
    @game.check_winners
    @game.bingo_cards.each do |bingo_card|
      BingoCardChannel.broadcast_to(
        bingo_card,
        ["bt-#{@bingo_tile.match_event.id}", @bingo_tile.match_event.status]
      )
      other_bingo_tile = bingo_card.bingo_tiles.find_by(match_event: @bingo_tile.match_event)
      if other_bingo_tile.present?
        if other_bingo_tile.status == "pending" && @bingo_tile.match_event.status == "happened"
          other_bingo_tile.status = "accepted"
        elsif other_bingo_tile.status == "accepted" && @bingo_tile.match_event.status == "not_happened"
          other_bingo_tile.status = "unchecked"
        end
        other_bingo_tile.save
      end
    end
    redirect_to game_bingo_card_path(@game, @bingo_tile.bingo_card)
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
    @bingo_card = BingoCard.find(params[:bingo_card_id])
  end
end
