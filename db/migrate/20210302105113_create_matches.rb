class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.datetime :date_time
      t.string :status
      t.string :team_1
      t.string :team_2
      t.json :data

      t.timestamps
    end
  end
end
