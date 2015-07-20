class MessagesController < ApplicationController
  def create
    sender = User.find_or_create_by(phone_number: params["From"])
    conversation = Conversation.current_conversation_for(user)

    if current_conversation.nil?
      receiver = User.random_user(user)
      conversation = Conversation.create(sender: user, receiver: receiver)
    else
      receiver = current_conversation.recipient(user)
    end

    conversation.deliver_message(body: params["Body"], sender: sender,
      receiver: receiver)

    render nothing: true
  end

end
