class User < ActiveRecord::Base
  has_many :messages
  has_many :sender_conversations, foreign_key: "sender_id", class_name: "Conversation"
  has_many :receiver_conversations, foreign_key: "receiver_id", class_name: "Conversation"

  def self.random_user(user)
    random = where("id != ?", user.id).sample
    if Conversation.current_conversation_for(random).nil?
      random
    else
      random_user(user)
    end
  end

  def all_conversations
    Conversation.where("sender_id = ? OR receiver_id = ?", id, id).uniq
  end

  def current_conversation
    all_conversations.find_by("expires_at > ?", Time.now.utc)
  end
end
