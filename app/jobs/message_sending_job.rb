class MessageSendingJob < ApplicationJob
  include ActionView::Helpers::DateHelper
  queue_as :default

  def perform(data)
    # Do something later
    sender = User.find(data['sender_id'])
    conversation = Conversation.find(data['conversation_id'])
    message = sender.send_message(conversation, data['message'])
    msg = render_message(sender, message)
    ActionCable.server.broadcast 'conversation_channel', { message: msg.merge(conversation_id: data['conversation_id']) }
  end

  private
  def render_message(current_user, message)
    # ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, current_user: current_user})
    {
      sender_id: message.sender.id,
      sender_email: message.sender.email,
      message_id: message.id,
      content: message.content,
      created_at: time_ago_in_words(message.created_at)
    }
  end
end
