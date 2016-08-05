class FriendRelation < ApplicationRecord
  #
  # Associations
  #
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  #
  # Validations
  #
  validates_uniqueness_of :friend_id, scope: :user_id
end
