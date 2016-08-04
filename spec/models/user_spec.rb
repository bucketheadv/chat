require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#conversation_to" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    it "should have the same conversation" do
      expect(user1.conversation_to(user2.id)).to eq user2.conversation_to(user1.id)
    end
  end
end