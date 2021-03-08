class SetDefaultStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :bingo_cards, :status, :string, default: "not_started"
    change_column :matches, :status, :string, default: "not_started"
  end
end
