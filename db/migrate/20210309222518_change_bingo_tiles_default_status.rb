class ChangeBingoTilesDefaultStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :bingo_tiles, :status, :string, default: "unchecked"
  end
end
