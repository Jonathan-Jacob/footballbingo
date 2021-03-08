class Group < ApplicationRecord
  belongs_to :user
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :games, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
