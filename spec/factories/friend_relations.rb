FactoryGirl.define do
  factory :friend_relation do
    user
    association :friend, factory: :user
  end
end
