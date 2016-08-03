require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe ".Associations" do
    it { is_expected.to have_many(:messages) }
    it { is_expected.to have_many(:user_conversation_relations) }
  end
end
