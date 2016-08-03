class MyController < ApplicationController
  def contacts
    @contacts = User.where.not(id: current_user.id)
  end

  def message_board
    @conversation_relation = current_user.sender_conversation_relations
  end
end
