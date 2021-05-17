#FocuesRelation                关注关系表
# user                         ：user                      被关注者
# follower                     ：user                      关注者
#
# user  =》（被关注）    follower
class FocuesRelation < ApplicationRecord
  belongs_to :user
  belongs_to :follower,class_name:"User",foreign_key:"follower_id"
end
