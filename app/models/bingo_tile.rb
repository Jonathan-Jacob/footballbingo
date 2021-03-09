class BingoTile < ApplicationRecord
  belongs_to :bingo_card
  belongs_to :match_event

  def update
    if status == "pending"
      if match_event.status == "happened"
        self.status = "accepted"
        save
        return "accepted"

      end
    elsif status == "accepted"
      if match_event.status == "not_happened"
        self.status = "not_happened"
        save
        return "reverted"

      end
    end
  end
  nil
end
