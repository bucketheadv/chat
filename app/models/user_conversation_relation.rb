class UserConversationRelation < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :sender_conversation, class_name: 'Conversation', foreign_key: 'conversation_id'
  belongs_to :receiver_conversation, class_name: 'Conversation', foreign_key: 'conversation_id'

  validates_uniqueness_of :receiver_id, scope: :sender_id

  scope :new_to_old, -> { order(updated_at: :desc) }
end
