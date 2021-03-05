class BingoTile < ApplicationRecord
  belongs_to :bingo_card
  belongs_to :match_event
end
