class MessageStatus < ApplicationRecord
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :message
end
