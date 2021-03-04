class AddColumnsToCompetition < ActiveRecord::Migration[6.0]
  def change
    add_column :competitions, :api_id, :integer
    add_column :competitions, :country, :string
  end
end
