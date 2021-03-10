class BingoCardChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    bingo_card = BingoCard.find(params[:id])
    stream_for bingo_card
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
