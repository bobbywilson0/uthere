class ChangeColumnTypeToDate < ActiveRecord::Migration
  def change
    remove_column :conversations, :expires_at
    add_column :conversations, :expires_at, :datetime
  end
end
