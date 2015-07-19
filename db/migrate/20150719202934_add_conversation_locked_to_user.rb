class AddConversationLockedToUser < ActiveRecord::Migration
  def change
    add_column :users, :conversation_locked, :boolean
  end
end
