class AddMatchEventToBingoTile < ActiveRecord::Migration[6.0]
  def change
    add_reference :bingo_tiles, :match_event, null: false, foreign_key: true
  end
end
