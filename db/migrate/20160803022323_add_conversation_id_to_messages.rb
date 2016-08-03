class AddConversationIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :conversation_id, :integer
    add_index :messages, :conversation_id
  end
end
