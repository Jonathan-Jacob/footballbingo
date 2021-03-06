class Game < ApplicationRecord
  belongs_to :match
  belongs_to :group
  belongs_to :chatroom, dependent: :destroy
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

  def winners?
    return false if winners.present?

    won = false
    names = []
    BingoCard.where(game: self).each do |bingo_card|
      if bingo_card.status == "bingo"
        Winner.create(game: self, user: bingo_card.user)
        won = true
        names.push(bingo_card.user.nickname)
      end
    end
    won ? names : nil
  end
end
