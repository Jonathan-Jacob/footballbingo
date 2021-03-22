class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :groups, dependent: :destroy
  has_many :bingo_cards, dependent: :destroy
  has_many :games, through: :bingo_cards
  has_many :winners, dependent: :destroy
  has_one_attached :photo

  include PgSearch::Model
  pg_search_scope :search_user,
                  against: :nickname,
                  using: {
                    tsearch: { prefix: true } # <-- now `superman batm` will return something!
                  }
end

# in rails c run the following line to make the user u an admin
# u.update_attribute :admin, true
