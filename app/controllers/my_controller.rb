class MyController < ApplicationController
  def contacts
    @contacts = current_user.friends
  end

  def message_board
    @conversation_relation = current_user.sender_conversation_relations
  end
end
