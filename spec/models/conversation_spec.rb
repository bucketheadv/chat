require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe ".Associations" do
    it { is_expected.to have_many(:messages) }
    it { is_expected.to have_many(:user_conversation_relations) }
  end

  describe "#get_sender" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    it "should get the correct user" do
      conversation = user1.conversation_to(user2.id)
      expect(conversation.get_sender(user2.id)).to eq user1
    end
  end

  describe "#get_receiver" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    it "should get the correct user" do
      conversation = user1.conversation_to(user2.id)
      expect(conversation.get_receiver(user1.id)).to eq user2
    end
  end
end
