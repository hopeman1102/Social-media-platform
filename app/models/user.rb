class User < ApplicationRecord
  has_secure_password

  VALID_USERNAME_REGEX = /\A^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,20}\z/i
  VALID_EMAIL_REGEX = /\A\s*[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\s*\z/i
  validates :user_name, presence: true, uniqueness: true, format: {with: VALID_USERNAME_REGEX}
  validates :email, presence: true, uniqueness: true, format: {with: VALID_EMAIL_REGEX}
  has_many :posts
  has_many :post_likes
end
