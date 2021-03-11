class Game < ApplicationRecord
  belongs_to :match
  belongs_to :group
  belongs_to :chatroom
  has_many :bingo_cards, dependent: :destroy
  has_many :winners, dependent: :destroy
  validates :match, uniqueness: { scope: :group, message: 'is already in group' }
  # validate :match_must_be_fresh

  def match_must_be_fresh
    errors.add(:match, "has already started") if too_late_to_start?
  end

  def too_late_to_start?
    match.status != "not_started" && match.date_time + 300 < Time.now.utc
  end

  def check_winners
    return false if winners.present?

    BingoCard.where(game: self).each do |bingo_card|
      Winner.create(game: self, user: bingo_card.user) if bingo_card.status == "bingo"
    end
    winners.present? ? true : false
  end
end
