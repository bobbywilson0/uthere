require 'rails_helper'

describe Conversation do

  describe "#recipient" do
    let(:sender) { User.create(phone_number: "+15555555555") }
    let(:receiver) { User.create(phone_number: "+14444444444") }
    subject { Conversation.create(sender: sender, receiver: receiver) }

    it "identifies the correct recipient" do
      expect(subject.recipient(sender)).to eq(receiver)
    end
  end

  describe "#deliver_message" do
    let(:sender) { User.create(phone_number: "+15555555555") }
    let(:receiver) { User.create(phone_number: "+14444444444") }
    subject { Conversation.create(sender: sender, receiver: receiver) }

    it "sends a message" do
      expect(subject.deliver_message("hi", sender, receiver)).to eq({body: "hi", to: "+14444444444", from: "+15017084577"})
    end

    it "creates a message model" do
      subject.deliver_message("hi", sender, receiver)
      expect(subject.messages.length).to eq(1)
    end
  end

  describe ".current_conversation_for" do

    context "expired conversation" do
      let(:user) {User.create(phone_number: "+15555555555")}
      let!(:conversation) { Conversation.create(sender_id: user.id, receiver_id: 2, expires_at: (Time.now.utc - 5.minutes))}

      it "doesn't find one" do
        expect(Conversation.current_conversation_for(user)).to eq(nil)
      end
    end

    context "non-expired conversation" do
      let(:user) {User.create(phone_number: "+15555555555")}
      let!(:conversation) { Conversation.create(sender_id: user.id, receiver_id: 2, expires_at: (Time.now.utc + 5.minutes))}

      it "finds one" do
        expect(Conversation.current_conversation_for(user)).to eq(conversation)
      end
    end
  end
end
