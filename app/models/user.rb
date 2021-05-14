class User < ApplicationRecord
  has_many :articles

  enum rule:{admin:1,normal:2}
end
