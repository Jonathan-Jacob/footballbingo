class CreateBingoCards < ActiveRecord::Migration[6.0]
  def change
    create_table :bingo_cards do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
