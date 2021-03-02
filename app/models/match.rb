class Match < ApplicationRecord
  has_many :games
  has_many :match_events

  validates :team_1, presence: true
  validates :team_2, presence: true
end
