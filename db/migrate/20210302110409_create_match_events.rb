class CreateMatchEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :match_events do |t|
      t.text :action
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end
  end
end
