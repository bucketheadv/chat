class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sended_messages,   class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'

  has_many :sender_conversation_relations, class_name: 'UserConversationRelation', foreign_key: 'sender_id'
  has_many :receiver_conversation_relations, class_name: 'UserConversationRelation', foreign_key: 'receiver_id'
  has_many :sender_conversations, through: :sender_conversation_relations, class_name: 'Conversation'
  has_many :receiver_conversations, through: :receiver_conversation_relations, class_name: 'Conversation'

  has_many :friend_relations
  has_many :friends, through: :friend_relations, class_name: 'User'

  #def conversation_relations
  #  (self.sender_conversation_relations | self.receiver_conversations).uniq
  #end

  # Get the conversation of two users, should be the same
  def conversation_to(receiver_id)
    relation = sender_conversation_relations.where(receiver_id: receiver_id).first
    return relation.sender_conversation if relation.present?
    relation = receiver_conversation_relations.where(sender_id: receiver_id).first
    if relation.present?
      conversation = relation.sender_conversation
      self.sender_conversation_relations.create(receiver_id: receiver_id, sender_conversation: conversation)
      return conversation
    end
    conversation = Conversation.joins(:messages).where(messages: { sender_id: self.id, receiver_id: receiver_id}).first
    conversation ||= Conversation.joins(:messages).where(messages: { sender_id: receiver_id, receiver_id: self.id}).first
    conversation ||= Conversation.create
    self.sender_conversation_relations.create(receiver_id: receiver_id, sender_conversation: conversation)
    conversation
  end

  # Unread messages from a conversation
  def unread_messages_from(conversation)
    id = conversation.is_a?(Conversation) ? conversation.id : id
    received_messages.joins(:message_statuses).where(message_statuses: { status: 0 }).where(conversation_id: id)
  end

  def unread_all_messages
    self.received_messages.joins(:message_statuses).where(message_statuses: { status: 0 })
  end

  def add_friend(user)
    user = user.is_a?(User) ? user : User.find(user)
    self.class.transaction do
      self.friends << user
      user.friends << self
    end
  end

  def remove_friend(user)
    user = user.is_a?(User) ? user : User.find(user)
    self.class.transaction do
      self.friend_relations.where(friend_id: user.id).destroy_all
      user.friend_relations.where(friend_id: self.id).destroy_all
    end
  end

  def send_message(conversation, message)
    receiver = conversation.get_reciever(self.id)
    message = conversation.messages.build(content: message, sender_id: self.id, receiver_id: receiver.id)
    message.save
    message
  end
end
