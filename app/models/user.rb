class User < ApplicationRecord
  has_secure_password

  VALID_USERNAME_REGEX = ^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,12}
  validates :user_name, presence: true, uniqueness: true, format: {with: VALID_USERNAME_REGEX}
  has_many :posts
end
