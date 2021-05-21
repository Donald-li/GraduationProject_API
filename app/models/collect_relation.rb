class CollectRelation < ApplicationRecord
  belongs_to :user
  belongs_to :article

  scope :sorted, -> {order(created_at: :desc)}
  scope :reverse_sorted, -> {sorted.reverse_order}

  def self.find_by_page(offset,pagesize)
    self.limit(pagesize).offset(offset)
  end

end
