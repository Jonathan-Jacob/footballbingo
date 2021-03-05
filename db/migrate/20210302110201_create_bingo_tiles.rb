class CreateBingoTiles < ActiveRecord::Migration[6.0]
  def change
    create_table :bingo_tiles do |t|
      t.references :bingo_card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
