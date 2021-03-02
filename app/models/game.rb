class Game < ApplicationRecord
  belongs_to :match
  belongs_to :group
end
