class AddNeedsToReplyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :needs_to_reply, :boolean
  end
end
