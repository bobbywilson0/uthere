class User < ActiveRecord::Base
  has_many :messages
  has_many :conversations

  def self.random_user(user)
    random = where("id != ?", user.id).sample
    if Conversation.current_conversation_for(random).nil?
      random
    else
      random_user(user)
    end
  end
end
