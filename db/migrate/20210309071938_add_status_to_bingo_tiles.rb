class AddStatusToBingoTiles < ActiveRecord::Migration[6.0]
  def change
    add_column :bingo_tiles, :status, :string, default: "not happened"
  end
end
