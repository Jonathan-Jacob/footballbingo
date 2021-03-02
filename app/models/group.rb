class Group < ApplicationRecord
  belongs_to :user
  has_many :users
  has_many :games

  validates :name, presence: true, uniqueness: true
end
