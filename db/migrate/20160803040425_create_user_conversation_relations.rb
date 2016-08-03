class CreateUserConversationRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :user_conversation_relations do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :conversation_id

      t.timestamps
    end

    add_index :user_conversation_relations, :sender_id
    add_index :user_conversation_relations, :receiver_id
    add_index :user_conversation_relations, :conversation_id
  end
end
