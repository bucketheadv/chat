require 'rails_helper'

RSpec.describe Message, type: :model do
  describe ".Associations" do
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to belong_to(:sender).class_name('User') }
    it { is_expected.to belong_to(:receiver).class_name('User') }
  end
end
