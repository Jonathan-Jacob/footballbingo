class BingoCard < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :bingo_tiles, dependent: :destroy
  validates :user, uniqueness: { scope: :game, message: 'already has a bingo card' }

  def populate
    create_tiles if status == "not_started" && game.match.date_time - Time.now.utc <= 900
    self.status = "ongoing"
    save
  end

  def create_tiles
    BingoTile.where(bingo_card: self).destroy_all
    MatchEvent.where(match: game.match).sample(16).each_with_index do |match_event, index|
      BingoTile.create(match_event: match_event, bingo_card: self, position: index)
    end
  end
end
