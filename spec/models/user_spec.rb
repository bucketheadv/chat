require 'rails_helper'

RSpec.describe User, type: :model do
  describe ".Associations" do
    it { is_expected.to have_many(:sended_messages).class_name('Message').with_foreign_key(:sender_id) }
    it { is_expected.to have_many(:received_messages).class_name('Message').with_foreign_key(:receiver_id) }
    it { is_expected.to have_many(:sender_conversation_relations).class_name('UserConversationRelation').with_foreign_key(:sender_id) }
    it { is_expected.to have_many(:receiver_conversation_relations).class_name('UserConversationRelation').with_foreign_key(:receiver_id) }
    it { is_expected.to have_many(:sender_conversations).through(:sender_conversation_relations).class_name('Conversation') }
    it { is_expected.to have_many(:receiver_conversations).through(:receiver_conversation_relations).class_name('Conversation') }
    it { is_expected.to have_many(:friend_relations) }
    it { is_expected.to have_many(:friends).through(:friend_relations).class_name('User') }
  end

  describe "#conversation_to" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }
    it "should have the same conversation" do
      expect(user1.conversation_to(user2.id)).to eq user2.conversation_to(user1.id)
    end

    it "should have different conversation" do
      expect(user1.conversation_to(user2.id)).not_to eq user1.conversation_to(user3.id)
    end
  end
end
