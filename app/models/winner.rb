class Winner < ApplicationRecord
  belongs_to :game
  belongs_to :user
  validates :user, uniqueness: { scope: :game, message: 'has already won the game' }
end
