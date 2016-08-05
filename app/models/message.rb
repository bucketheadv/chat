class Message < ApplicationRecord
  #
  # Associations
  #
  belongs_to :sender,   class_name: 'User', foreign_key: 'sender_id',   required: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', required: true
  belongs_to :conversation
  has_many   :message_statuses

  #
  # Validations
  #
  validates_presence_of :content

  #
  # Callbacks
  #
  before_save :set_message_status, if: proc { |msg| msg.new_record? }
  after_commit :generate_conversation_and_touch

  #
  # Private Methods
  #
  private

  # 给接收者设置一条未读消息
  def set_message_status
    self.message_statuses.build(receiver_id: receiver.id)
  end

  def generate_conversation_and_touch
    conversation = receiver.conversation_to(sender.id)
    conversation.user_conversation_relations.map(&:touch)
  end
end
