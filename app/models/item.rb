class Item < ApplicationRecord

  belongs_to :genre
  has_many :order_details
  has_many :cart_items, dependent: :destroy

  attachment :image

  # 消費税込みの値段表示
  def tax_include
    tax = 1.10
    (price * tax).round
  end

end
