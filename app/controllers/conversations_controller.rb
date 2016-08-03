class ConversationsController < ApplicationController
  def new
    conversation = current_user.conversation_to(params[:receiver_id])
    redirect_to conversation
  end

  def show
    @conversation = Conversation.find(params[:id])
    msgs = current_user.unread_messages_from(@conversation)
    msg_statuses = MessageStatus.where(message_id: msgs.pluck(:id), receiver_id: current_user.id)
    msg_statuses.update_all(status: 1) if msg_statuses.exists?
  end

  def delete_my_conversation
    sender_conversation = current_user.sender_conversation_relations.find(params[:id])
    sender_conversation.destroy
    redirect_to my_message_board_path
  end
end
