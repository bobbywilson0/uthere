class User < ActiveRecord::Base
  has_many :posts, foreign_key: "sender_id", class_name: "Message"
  has_many :replies, foreign_key: "receiver_id", class_name: "Message"
end
