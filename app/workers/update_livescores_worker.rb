class UpdateLivescoresWorker
  include Sidekiq::Worker

  def perform
    Match.update_livescores.each do |match|
      if MatchEvent.update(match) # returns true if a match event has been reverted
        match.games.each do |game|
          # create chat message that an event has been reverted
        end
      end
    end
  end
end
