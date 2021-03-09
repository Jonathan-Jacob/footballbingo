class PopulateBingoCardsWorker
  include Sidekiq::Worker

  def perform
    BingoCard.all.each(&:populate)
  end
end
