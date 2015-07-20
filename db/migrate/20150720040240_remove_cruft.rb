class RemoveCruft < ActiveRecord::Migration
  def change
    remove_column :messages, :user_id
    remove_column :users, :needs_to_reply
    remove_column :users, :conversation_locked
  end
end
