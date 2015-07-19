class RemoveFieldsFromMessage < ActiveRecord::Migration
  def change
    add_column(:messages, :user_id, :integer)
    remove_column(:messages, :sender_id)
    remove_column(:messages, :reply)
    remove_column(:messages, :receiver_id)
  end
end
