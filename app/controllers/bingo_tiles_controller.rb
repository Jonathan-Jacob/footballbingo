class BingoTilesController < ApplicationController
  before_action :set_game

  include ActionView::Helpers::TextHelper

  def show
    @bingo_tile = BingoTile.find(params[:id])
    @bingo_tiles = @bingo_card.bingo_tiles
    authorize @bingo_tile
    @message = Message.new
    render 'bingo_cards/show'
  end

  def update
    @bingo_tile = BingoTile.find(params[:id])
    authorize @bingo_tile

    # change color of bingo tiles through clicking
    @bingo_tile.check

    @game.bingo_cards.each do |bingo_card|
      # change color of all game players' bingo tiles if API returns news
      BingoCardChannel.broadcast_to(
        bingo_card,
        ["bt-#{@bingo_tile.match_event.id}", @bingo_tile.match_event.status]
      )

      # change status of bingo_tile with same match event from other players
      other_bingo_tile = bingo_card.bingo_tiles.find_by(match_event: @bingo_tile.match_event)
      if other_bingo_tile.present?
        if other_bingo_tile.status == "pending" && @bingo_tile.match_event.status == "happened"
          other_bingo_tile.status = "accepted"
        elsif other_bingo_tile.status == "accepted" && @bingo_tile.match_event.status == "not_happened"
          other_bingo_tile.status = "unchecked"
        end
        other_bingo_tile.save
      end

      if bingo_card.new_bingo?
        BingoCardChannel.broadcast_to(
          bingo_card,
          ["bingo"]
        )
        sleep(5) if bingo_card == @bingo_card
      end
    end

    #WIP
    if (names = @game.winners?)
      content = "Congratulations to the #{pluralize(@game.winners.count, 'winner')}: #{names.sort.to_sentence}!"
      message = Message.new(chatroom: @game.chatroom, user: User.find_by(nickname: "BingoBot"), content: content)
      if message.save
        ChatroomChannel.broadcast_to(
          @game.chatroom,
          render_to_string(partial: "messages/message", locals: { message: message })
        )
      end
    end

    #needed for rendering bingo_card show
    @bingo_tiles = @bingo_card.bingo_tiles
    @message = Message.new

    render 'bingo_cards/show'
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
    @bingo_card = BingoCard.find(params[:bingo_card_id])
  end
end
