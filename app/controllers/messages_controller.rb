class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find(params[:conversation_id])
    receiver = @conversation.get_reciever(current_user.id)
    @message = @conversation.messages.build(message_params.merge(sender_id: current_user.id, receiver_id: receiver.id))
    if @message.save
      flash[:notice] = 'Message sended.'
      redirect_to @conversation
    else
      flash[:notice] = 'Message send failed.'
      redirect_back fallback_location: conversation_path(@conversation)
    end
  end

  def destroy
    @msg = current_user.sended_messages.find_by(id: params[:id])
    @msg.destroy
    redirect_back fallback_location: conversation_path(params[:conversation_id])
  end

  private
  def message_params
    params.require(:message).permit(:content)
  end
end
