class BingoCard < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :bingo_tiles, dependent: :destroy
  validates :user, uniqueness: { scope: :game, message: 'already has a bingo card' }

  def populate
    create_tiles if status == "not_started" && game.match.date_time - Time.now.utc <= 900
  end

  def create_tiles
    BingoTile.where(bingo_card: self).destroy_all
    MatchEvent.where(match: game.match).sample(16).each_with_index do |match_event, index|
      BingoTile.create(match_event: match_event, position: index, bingo_card: self)
    end
    self.status = "ongoing"
    save
  end

  def num_pending
    BingoTile.where(bingo_card: self, status: "pending").count
  end

  def new_bingo?
    if status == "ongoing" && bingo?
      self.status = "bingo"
      save
      return true

    end
    false
  end

  def bingo?
    card_tiles = BingoTile.where(bingo_card: self).sort_by { |bingo_tile| bingo_tile.position }
    return false if card_tiles.count != 16

    return true if card_tiles[0].status == "accepted" && card_tiles[1].status == "accepted" && card_tiles[2].status == "accepted" && card_tiles[3].status == "accepted"

    return true if card_tiles[4].status == "accepted" && card_tiles[5].status == "accepted" && card_tiles[6].status == "accepted" && card_tiles[7].status == "accepted"

    return true if card_tiles[8].status == "accepted" && card_tiles[9].status == "accepted" && card_tiles[10].status == "accepted" && card_tiles[11].status == "accepted"

    return true if card_tiles[12].status == "accepted" && card_tiles[13].status == "accepted" && card_tiles[14].status == "accepted" && card_tiles[15].status == "accepted"

    return true if card_tiles[0].status == "accepted" && card_tiles[4].status == "accepted" && card_tiles[8].status == "accepted" && card_tiles[12].status == "accepted"

    return true if card_tiles[1].status == "accepted" && card_tiles[5].status == "accepted" && card_tiles[9].status == "accepted" && card_tiles[13].status == "accepted"

    return true if card_tiles[2].status == "accepted" && card_tiles[6].status == "accepted" && card_tiles[10].status == "accepted" && card_tiles[14].status == "accepted"

    return true if card_tiles[3].status == "accepted" && card_tiles[7].status == "accepted" && card_tiles[11].status == "accepted" && card_tiles[15].status == "accepted"

    return true if card_tiles[0].status == "accepted" && card_tiles[5].status == "accepted" && card_tiles[10].status == "accepted" && card_tiles[15].status == "accepted"

    return true if card_tiles[3].status == "accepted" && card_tiles[6].status == "accepted" && card_tiles[9].status == "accepted" && card_tiles[12].status == "accepted"

    false
  end
end
