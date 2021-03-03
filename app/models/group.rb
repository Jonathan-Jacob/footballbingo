class Group < ApplicationRecord
  belongs_to :user
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :games

  validates :name, presence: true, uniqueness: true
end
