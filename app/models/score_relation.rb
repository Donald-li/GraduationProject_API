#ScoreRelation               表示每篇文章与用户的评分关系
# user              :user               为此文章评分的用户
# article           :article            被评分的文章
# score             :float              被评价的分数

class ScoreRelation < ApplicationRecord
  belongs_to :user
  belongs_to :article
end
