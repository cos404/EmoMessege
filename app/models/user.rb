class User < ApplicationRecord
  has_secure_token

  validates :username, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true

  has_many  :messages
end
