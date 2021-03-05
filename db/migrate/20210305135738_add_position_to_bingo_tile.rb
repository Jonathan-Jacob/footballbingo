class AddPositionToBingoTile < ActiveRecord::Migration[6.0]
  def change
    add_column :bingo_tiles, :position, :integer
  end
end
