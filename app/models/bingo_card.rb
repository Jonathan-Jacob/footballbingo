class BingoCard < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :bingo_tiles
  validates :user, uniqueness: { scope: :game, message: 'already has a bingo card' }

  def populate
    BingoTile.where(bingo_card: self).destroy_all
    MatchEvent.where(match: game.match).sample(16).each_with_index do |match_event, index|
      BingoTile.create(match_event: match_event, bingo_card: self, position: index)
    end
    binding.pry
    # 16 MatchEvents als Array
  end
end
