class AddColumnToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :home_color, :string, default: "#AAAAAA"
    add_column :matches, :away_color, :string, default: "#AAAAAA"
  end
end
