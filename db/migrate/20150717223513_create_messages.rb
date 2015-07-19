class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sender_id
      t.string :body
      t.string :receiver_id
      t.string :reply

      t.timestamps null: false
    end
  end
end
