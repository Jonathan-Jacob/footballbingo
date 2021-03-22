class AddColumnToUserGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :user_groups, :status, :string, default: "member"
  end
end
