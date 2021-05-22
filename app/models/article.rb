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

  has_many :score_relations,dependent: :destroy
  has_many :thumb_relations,dependent: :destroy
  has_many :collect_relation,dependent: :destroy

  has_many :comments,dependent: :destroy

  enum section: {movie:1,game:2,music:3,dance:4,food:5,comic:6}

  scope :sorted, -> {order(created_at: :desc)}
  scope :reverse_sorted, -> {sorted.reverse_order}

  scope :sorted_score, -> {order(score: :desc)}
  scope :reverse_sorted_score, -> {sorted.reverse_order}

  def self.find_by_page(offset,pagesize)
    self.limit(pagesize).offset(offset)
  end

end
