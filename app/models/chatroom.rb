class Chatroom < ApplicationRecord
  has_many :messages
  has_one :group
  has_one :game
end
