class UpdateMatchWorker
  include Sidekiq::Worker

  def perform
    Match.update_matches
    Match.all.each do |match|
      MatchEvent.generate(match) if match.match_events.empty?
    end
  end
end
