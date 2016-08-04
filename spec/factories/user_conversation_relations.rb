FactoryGirl.define do
  factory :user_conversation_relation do
    association :sender, factory: :user
    association :receiver, factory: :user
    association :sender_conversation, factory: :conversation
  end
end
