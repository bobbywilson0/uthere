class MessagesController < ApplicationController
  def create
    sender = User.find_or_create_by(phone_number: params["From"])
    conversation = sender.last_conversation

    if conversation.nil?
      receiver = User.random_user(sender)
      conversation = Conversation.create(sender: sender, receiver: receiver)
    elsif conversation.expired?
      [conversation.sender, conversation.receiver].each do |user|
        conversation.deliver_admin_messsage(
          body: "Your conversation has expired, send another message to connect with someone new.",
          receiver: user)
      end
      conversation.destroy
    else
      receiver = conversation.recipient(sender)
    end

    conversation.deliver_message(body: params["Body"], sender: sender,
      receiver: receiver)

    render nothing: true
  end
end
