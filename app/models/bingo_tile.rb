class BingoTile < ApplicationRecord
  belongs_to :bingo_card
  belongs_to :match_event

  def check
    if match_event.status == "happened"
      self.status = "accepted"
      save
      return "accepted"

    elsif status == "pending"
      self.status = "unchecked"
      save
      return

    elsif bingo_card.num_pending >= 2
      return "too_many_pending"

    else
      self.status = "pending"
      save
      return "pending"

    end
  end

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
end
