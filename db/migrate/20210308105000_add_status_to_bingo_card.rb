class AddStatusToBingoCard < ActiveRecord::Migration[6.0]
  def change
    add_column :bingo_cards, :status, :string
  end
end
