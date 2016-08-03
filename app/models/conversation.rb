class Conversation < ApplicationRecord
  has_many :messages
  has_many :user_conversation_relations, dependent: :destroy

  def get_sender(receiver_id)
    user_conversation_relations.find_by(receiver_id: receiver_id).try(:sender)
  end

  def get_reciever(sender_id)
    user_conversation_relations.find_by(sender_id: sender_id).try(:receiver)
  end
end
