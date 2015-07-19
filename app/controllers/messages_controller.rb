class MessagesController < ApplicationController
  def create
    user = User.create_with(conversation_locked: false).find_or_create_by(phone_number: params["From"])

    current_conversation = Conversation.where("sender_id = ? OR receiver_id = ?", user.id, user.id).first
    receiver = nil

    if current_conversation.nil?
      receiver = User.where.not(id: user.id, conversation_locked: false).sample
      current_conversation = Conversation.create(sender_id: user.id, receiver_id: receiver.id)
      user.update_attribute(:conversation_locked, true)
      receiver.update_attribute(:conversation_locked, true)
    else
      if user.id == current_conversation.sender_id
        receiver = current_conversation.receiver
      else
        receiver = current_conversation.sender
      end
    end

    current_conversation.messages << Message.create(body: params["Body"], sender_id: user.id, receiver_id: receiver.id)

    Twilio::REST::Client.new.messages.create(from: '+15017084577',
                           to: receiver.phone_number,
                           body: params["Body"])

    render nothing: true
  end

end
