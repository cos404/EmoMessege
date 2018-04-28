class Message < ApplicationRecord
  belongs_to  :user

  validates :user, presence: true
  validates :service, presence: true
  validates :recipient, presence: true
  validates :message, presence: true

  enum service: [:telegram, :viber, :whats_up]
end
