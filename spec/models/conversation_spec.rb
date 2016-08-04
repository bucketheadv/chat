require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe ".Associations" do
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:user_conversation_relations).dependent(:destroy) }
  end

  describe "#get_sender" do
    let(:user_conversation_relation) { FactoryGirl.create(:user_conversation_relation) }
    it "should get the correct user" do
      conversation = user_conversation_relation.sender_conversation
      expect(conversation.get_sender(user_conversation_relation.receiver_id)).to eq user_conversation_relation.sender
    end
  end

  describe "#get_receiver" do
    let(:user_conversation_relation) { FactoryGirl.create(:user_conversation_relation) }
    it "should get the correct user" do
      conversation = user_conversation_relation.receiver_conversation
      expect(conversation.get_receiver(user_conversation_relation.sender_id)).to eq user_conversation_relation.receiver
    end
  end
end
