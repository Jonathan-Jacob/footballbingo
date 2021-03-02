class BingoCard < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :bingo_tiles
end
