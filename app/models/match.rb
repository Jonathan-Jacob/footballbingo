class Match < ApplicationRecord
  has_many :games

  validates :team_1, presence: true
  validates :team_2, presence: true
end
