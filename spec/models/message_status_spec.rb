require 'rails_helper'

RSpec.describe MessageStatus, type: :model do
  describe ".Associations" do
    it { is_expected.to belong_to(:receiver).class_name('User').with_foreign_key(:receiver_id) }
    it { is_expected.to belong_to(:message) }
  end
end
