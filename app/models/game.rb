class Game < ApplicationRecord
  belongs_to :match
  belongs_to :group
  has_many :bingo_cards
end
