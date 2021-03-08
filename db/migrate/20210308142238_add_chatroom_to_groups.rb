class AddChatroomToGroups < ActiveRecord::Migration[6.0]
  def change
    add_reference :groups, :chatroom, null: false, foreign_key: true
  end
end
