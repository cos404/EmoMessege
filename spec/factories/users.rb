FactoryBot.define do
  factory :user do
    username {Faker::Internet.user_name}
    token {Faker::Internet.password(8)}
  end
end