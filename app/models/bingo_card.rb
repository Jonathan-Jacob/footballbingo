class BingoCard < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :bingo_tiles
  validates :user, uniqueness: { scope: :game, message: 'already has a bingo card' }
end
