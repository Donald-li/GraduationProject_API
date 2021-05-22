#Message                 消息模型
# user                   :user                     消息发送者
# recevier               :user                     消息接受者
# body                   :text                     消息主体
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :receiver,class_name:"User",foreign_key:'receiver_id'
end
