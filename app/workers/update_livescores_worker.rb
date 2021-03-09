class UpdateLivescoresWorker
  include Sidekiq::Worker

  def perform
    Match.update_livescores
  end
end
