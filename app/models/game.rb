class Game < ApplicationRecord
  belongs_to :match
  belongs_to :group
  has_many :bingo_cards, dependent: :destroy
  validates :match, uniqueness: { scope: :group, message: 'is already in group' }
  validate :match_must_be_fresh

  def match_must_be_fresh
    if too_late_to_start?
      errors.add(:match, "has already started")
    end
  end

  def too_late_to_start?
    self.match.status != "not_started" && self.match.date_time + 300 < Time.now.utc
  end
end
