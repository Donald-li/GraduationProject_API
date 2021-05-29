#Message                 消息模型
# user                   :user                     消息发送者
# recevier               :user                     消息接受者
# body                   :text                     消息主体
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :receiver,class_name:"User",foreign_key:'receiver_id'

  enum state: {show:1,hidden:2}

  before_save :default_value

  def default_value
    if self .state.blank?
      self.state = 1
    end
  end
end
