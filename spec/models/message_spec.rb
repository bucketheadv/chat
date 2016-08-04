require 'rails_helper'

RSpec.describe Message, type: :model do
  describe ".Associations" do
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to belong_to(:sender).class_name('User').with_foreign_key(:sender_id) }
    it { is_expected.to belong_to(:receiver).class_name('User').with_foreign_key(:receiver_id) }
    it { is_expected.to have_many(:message_statuses) }
  end

  describe ".Validations" do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe ".Callbacks" do
    it { is_expected.to callback(:set_message_status).before(:save) }
    it { is_expected.to callback(:generate_conversation_and_touch).after(:commit) }
  end
end
