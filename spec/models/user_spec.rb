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

  context ".unread messages count" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    describe "#unread_message_from" do
      it "should has correct unread messages count" do
        conversation = user1.conversation_to(user2.id)
        user1.send_message(conversation, Faker::Lorem.word)
        expect(user2.unread_messages_from(conversation).count).to eq 1
      end
    end

    describe "#unread_all_messages" do
      it "should has correct unread messages count" do
        conversation = user1.conversation_to(user2.id)
        user1.send_message(conversation, Faker::Lorem.word)
        expect(user2.unread_all_messages.count).to eq 1
      end
    end
  end

  context ".friends" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    describe "#add_friend" do
      it do
        user1.add_friend(user2)
        expect(user1.friends).to include(user2)
        expect(user2.friends).to include(user1)
      end
    end

    describe "#remove_friend" do
      it do
        user1.add_friend(user2)
        user1.remove_friend(user2)
        user1.reload
        user2.reload
        expect(user1.friends).not_to include(user2)
        expect(user2.friends).not_to include(user1)
      end
    end
  end

  describe "#send_message" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    it "should send a message" do
      conversation = user1.conversation_to(user2)
      word = Faker::Lorem.word
      message = user1.send_message(conversation, word)
      expect(message.content).to eq word
    end
  end
end
