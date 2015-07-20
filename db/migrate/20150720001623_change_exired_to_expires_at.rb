class ChangeExiredToExpiresAt < ActiveRecord::Migration
  def change
    rename_column(:conversations, :expired, :expires_at)
  end
end
