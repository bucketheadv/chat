class Conversation < ApplicationRecord
  #
  # Associations
  #
  has_many :messages, dependent: :destroy
  has_many :user_conversation_relations, dependent: :destroy

  #
  # 通过receiver_id查找本次会话的sender
  #
  # @param [Integer] receiver_id 对话的接收者ID
  #
  # @return [User] 返回该对话的发送者
  #
  def get_sender(receiver_id)
    user_conversation_relations.find_by(receiver_id: receiver_id).try(:sender)
  end

  #
  # 通过sender_id查找本次会话的receiver
  #
  # @param [Integer] sender_id 对话的发送者ID
  #
  # @return [User] 返回该对话的接收者
  #
  def get_receiver(sender_id)
    user_conversation_relations.find_by(sender_id: sender_id).try(:receiver)
  end
end
