class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_one :group
  has_one :game
end
