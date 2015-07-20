class Conversation < ActiveRecord::Base
  has_many :messages
  belongs_to :sender, foreign_key: 'sender_id', class_name: "User"
  belongs_to :receiver, foreign_key: 'receiver_id', class_name: "User"

  def self.current_conversation_for(user)
    find_by("expires_at > ? AND (sender_id = ? OR receiver_id = ?)", Time.now.utc, user.id, user.id)
  end

  def recipient(user)
    if user == sender
      receiver
    else
      sender
    end
  end

  def deliver_message(body, sender, receiver)
    update_attribute(:expires_at, Time.now + 5.minutes)
    messages << Message.create(body: body, sender: sender, receiver: receiver)

    if Rails.env.production?
      Twilio::REST::Client.new.messages.create(from: '+15017084577',
        to: receiver.phone_number,
        body: body)
    else
      { from: '+15017084577',
        to: receiver.phone_number,
        body: body }
    end
  end
end
