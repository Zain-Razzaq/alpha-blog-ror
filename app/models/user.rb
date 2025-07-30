
class User < ApplicationRecord
  has_secure_password
  has_many :blogs, dependent: :destroy
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :name, presence: true
end