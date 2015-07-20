class MessagesController < ApplicationController
  def create
    sender = User.find_or_create_by(phone_number: params["From"])
    conversation = sender.current_conversation

    if current_conversation.nil?
      receiver = User.random_user(sender)
      conversation = Conversation.create(sender: sender, receiver: receiver)
    else
      receiver = conversation.recipient(sender)
    end

    conversation.deliver_message(body: params["Body"], sender: sender,
      receiver: receiver)

    render nothing: true
  end

end
