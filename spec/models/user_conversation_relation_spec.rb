require 'rails_helper'

RSpec.describe UserConversationRelation, type: :model do
  describe ".Associations" do
    it { is_expected.to belong_to(:sender).class_name('User').with_foreign_key(:sender_id) }
    it { is_expected.to belong_to(:receiver).class_name('User').with_foreign_key(:receiver_id) }
    it { is_expected.to belong_to(:sender_conversation).class_name('Conversation').with_foreign_key(:conversation_id)}
    it { is_expected.to belong_to(:receiver_conversation).class_name('Conversation').with_foreign_key(:conversation_id)}
  end

  describe ".Validations" do
    it { is_expected.to validate_uniqueness_of(:receiver_id).scoped_to(:sender_id) }
  end

end
