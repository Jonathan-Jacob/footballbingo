class AddCompetitionToMatch < ActiveRecord::Migration[6.0]
  def change
    add_reference :matches, :competition, null: false, foreign_key: true
  end
end
