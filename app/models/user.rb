class User < ApplicationRecord
  has_secure_password

  VALID_USERNAME_REGEX = /\A^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,12}\z/i
  validates :user_name, presence: true, uniqueness: true, format: {with: VALID_USERNAME_REGEX}
  has_many :posts
  has_many :post_likes
end
