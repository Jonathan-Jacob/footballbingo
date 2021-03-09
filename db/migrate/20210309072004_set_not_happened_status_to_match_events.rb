class SetNotHappenedStatusToMatchEvents < ActiveRecord::Migration[6.0]
  def change
    change_column :match_events, :status, :string, default: "not_happened"
  end
end
