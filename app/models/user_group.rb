class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :user, uniqueness: { scope: :group, message: 'is already in group' }
end
