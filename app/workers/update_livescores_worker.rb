class UpdateLivescoresWorker
  include Sidekiq::Worker

  def perform
    Match.update_livescores.each do |match|
      if MatchEvent.update(match) # returns true if a match event has been reverted
        match.games.each do |game|
          # create chat message that an event has been reverted
        end
      end
      match.bingo_cards.each do |bingo_card|
        match.match_events.each do |match_event|
          BingoCardChannel.broadcast_to(
            bingo_card,
            ["bt-#{match_event.id}", match_event.status]
          )
        end
        if bingo_card.new_bingo?
          BingoCardChannel.broadcast_to(
            bingo_card,
            ["bingo"]
          )
        end
      end
      match.games.each do |game|
        if game.check_winners
          ChatbotChannel.broadcast_to(
            game.chatroom,
            render_to_string(partial: "message_bot", locals: { game: game })
          )
        end
      end
    end
  end
end
