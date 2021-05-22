#user            用户模型
# id            ：integer       用户id
# account       ：text          用户账号
# name          ：text          用户昵称
# password      ：text          用户密码
# rule          ：integer       用户角色      1：admin--管理员  2：normal--普通用户
# img           ：text          用户头像
# article       ：article       用户发表的文章
# star_articles ：star_articles 用户收藏的文章

class User < ApplicationRecord
  has_many :articles
  has_many :star_articles,class_name: "Article",foreign_key:"collector_id"

  has_many :score_relations,dependent: :destroy
  has_many :thumb_relations,dependent: :destroy
  has_many :collect_relations,dependent: :destroy

  has_many :comment,dependent: :destroy

  has_many :focues_relations,dependent: :destroy
  has_many :followers,class_name: "FocuesRelation",foreign_key:"follower_id",dependent: :destroy

  enum rule:{admin:1,normal:2}

  def self.commone
    self.select("id,account,name,rule,img,article,star_articles")
  end
end
