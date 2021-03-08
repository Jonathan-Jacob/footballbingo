class UpdateMatchWorker
  include Sidekiq::Worker

  def perform
    Match.update_matches
  end
end
