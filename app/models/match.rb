class Match < ApplicationRecord

  validates :team_1, presence: true
  validates :team_2, presence: true
end
