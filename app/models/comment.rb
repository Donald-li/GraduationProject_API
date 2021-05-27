class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  enum state: {show:1,hidden:2}

  before_save :default_value

  def default_value
    self.state = 1
  end
end
