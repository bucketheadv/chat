class MyController < ApplicationController
  def contacts
    @contacts = current_user.friends.page(params[:page]).per(params[:count])
  end

  def message_board
    @conversation_relations = current_user.sender_conversation_relations.page(params[:page]).per(params[:count])
  end
end
