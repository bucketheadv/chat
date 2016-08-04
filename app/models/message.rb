class Message < ApplicationRecord
  belongs_to :sender,   class_name: 'User', foreign_key: 'sender_id',   required: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', required: true
  belongs_to :conversation
  has_many   :message_statuses

  validates_presence_of :content

  before_save :set_message_status, if: proc { |msg| msg.new_record? }
  after_commit :generate_conversation_and_touch

  private
  def set_message_status
    self.message_statuses.build(receiver_id: receiver.id)
  end

  def generate_conversation_and_touch
    conversation = receiver.conversation_to(sender.id)
    conversation.user_conversation_relations.map(&:touch)
  end
end
