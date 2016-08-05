class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #
  # Associations
  #
  has_many :sended_messages,   class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'

  has_many :sender_conversation_relations, class_name: 'UserConversationRelation', foreign_key: 'sender_id'
  has_many :receiver_conversation_relations, class_name: 'UserConversationRelation', foreign_key: 'receiver_id'
  has_many :sender_conversations, through: :sender_conversation_relations, class_name: 'Conversation'
  has_many :receiver_conversations, through: :receiver_conversation_relations, class_name: 'Conversation'

  has_many :friend_relations
  has_many :friends, through: :friend_relations, class_name: 'User'

  #
  # Instance Methods
  #

  #
  # 获取两个用户之间的会话句柄，两个用户之间的会话是唯一的
  #
  # @param [User] 接收者或接收者ID
  #
  # @return [Conversation] 返回与该接收者的对话句柄
  #
  def conversation_to(receiver)
    receiver_id = receiver.is_a?(User) ? receiver.id : receiver
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

  #
  # 获取一个会话下的所有未读消息
  #
  # @param [Conversation] 会话
  #
  # @return [ActiveRecord::Relation] 所有未读消息的集合
  #
  def unread_messages_from(conversation)
    id = conversation.is_a?(Conversation) ? conversation.id : id
    received_messages.joins(:message_statuses).where(message_statuses: { status: :unread }).where(conversation_id: id)
  end

  #
  # 获取所有对话下的未读消息
  #
  # @return [ActiveRecord::Relation] 所有未读消息的集合
  #
  def unread_all_messages
    self.received_messages.joins(:message_statuses).where(message_statuses: { status: :unread })
  end

  #
  # 添加一个朋友
  #
  # @param [User] 目标用户
  #
  # @return [nil]
  #
  def add_friend(user)
    user = user.is_a?(User) ? user : User.find(user)
    self.class.transaction do
      self.friends << user
      user.friends << self
    end
  end

  #
  # 删除一个朋友
  #
  # @param [User] 目标用户
  #
  # @return [nil]
  #
  def remove_friend(user)
    user = user.is_a?(User) ? user : User.find(user)
    self.class.transaction do
      self.friend_relations.where(friend_id: user.id).destroy_all
      user.friend_relations.where(friend_id: self.id).destroy_all
    end
  end

  #
  # 发送一条消息到一个对话
  #
  # @param [Conversation, String] 对话，和要发送的字符串
  #
  # @return [Message] 发送的Message对象
  #
  def send_message(conversation, content)
    receiver = conversation.get_receiver(self.id)
    message = conversation.messages.build(content: content, sender_id: self.id, receiver_id: receiver.id)
    message.save
    message
  end
end
