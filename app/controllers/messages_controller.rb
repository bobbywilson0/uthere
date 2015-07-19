class MessagesController < ApplicationController
  def create
    sender = User.find_or_create_by(phone_number: params["From"])


    if sender.needs_to_reply?
      # Reply
      message = Message.find_by(receiver_id: sender.id)
      receiver = message.sender
      message.update_attribute(:reply, params["Body"])
      sender.update_attribute(:needs_to_reply, false)
      Twilio::REST::Client.new.messages.create(from: '+15017084577',
                             to: receiver.phone_number,
                             body: message.reply)
    else
      # Create new post
      receiver = User.where.not(id: sender.id).offset(rand(User.count - 1)).first
      message = sender.posts.create(body: params["Body"], receiver_id: receiver.id)
      receiver.update_attribute(:needs_to_reply, true)
      Twilio::REST::Client.new.messages.create(from: '+15017084577',
                             to: receiver.phone_number,
                             body: message.body)
    end


    render nothing: true
  end
end
