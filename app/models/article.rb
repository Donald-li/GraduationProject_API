#Article         文章模型
# id            ：integer           文章id
# title         ：text              文章标题
# body          ：text              文章主体
# score         ：float             文章评分
# section       ：integer           文章板块         movie:1,game:2,music:3,dance:4,food:5,comic:6
# thumbs        ：integer           文章点赞数
# user          ：user              发表者
# collector     ：user              收藏者

class Article < ApplicationRecord
  belongs_to :user
  belongs_to :collector,class_name: "User",foreign_key:"collector_id"

  enum section: {movie:1,game:2,music:3,dance:4,food:5,comic:6}

end
