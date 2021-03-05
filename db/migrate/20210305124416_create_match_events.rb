class CreateMatchEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :match_events do |t|
      t.references :match, null: false, foreign_key: true
      t.string :action
      t.string :agent
      t.integer :amount
      t.string :status
      t.string :description

      t.timestamps
    end
  end
end
