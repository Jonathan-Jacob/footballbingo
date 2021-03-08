class UpdateMatchWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'important'

  def perform
    Match.update_matches
  end
end
