class AddApiIdToMatch < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :api_id, :integer
  end
end
