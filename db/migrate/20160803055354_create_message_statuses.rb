class CreateMessageStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :message_statuses do |t|
      t.integer :message_id
      t.integer :receiver_id
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :message_statuses, :message_id
    add_index :message_statuses, :receiver_id
  end
end
