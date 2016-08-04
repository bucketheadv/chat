FactoryGirl.define do
  factory :message do
    sender_id 1
    receiver_id 1
    content "MyText"
    association :receiver, factory: :user
  end
end
