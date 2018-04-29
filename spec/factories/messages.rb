FactoryBot.define do
  factory :message do
    user {create :user}
    service {rand(0..2)}
    recipient {Faker::Internet.user_name}
    message {Faker::Lorem.sentences(1)}
    attempts 0
  end
end