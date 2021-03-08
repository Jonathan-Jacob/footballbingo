class Game < ApplicationRecord
  belongs_to :match
  belongs_to :group
  has_many :bingo_cards, dependent: :destroy
  validates :match, uniqueness: { scope: :group, message: 'is already in group' }
end
