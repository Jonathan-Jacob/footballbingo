class Competition < ApplicationRecord
  has_many :matches, dependent: :destroy
end
