require 'rails_helper'

RSpec.describe FriendRelation, type: :model do
  describe ".Associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:friend).class_name('User').with_foreign_key('friend_id') }
  end

  describe ".Validations" do
    it { is_expected.to validate_uniqueness_of(:friend_id).scoped_to(:user_id) }
  end
end
