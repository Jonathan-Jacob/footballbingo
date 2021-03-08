class UpdateLivescoresWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'important'

  def perform
    Match.update_livescores
  end
end
