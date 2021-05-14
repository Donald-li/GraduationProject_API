class Article < ApplicationRecord
  belongs_to :user

  enum section: {movie:1,game:2,music:3,dance:4,food:5,comic:6}

end
