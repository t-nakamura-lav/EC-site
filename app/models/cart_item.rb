class CartItem < ApplicationRecord
  
  belongs_to :customer
  belongs_to :item
  
  #追加メソッド
  # 小計
  def subtotal
    self.amount * self.item.tax_include
  end
  
  # 合計
  def total
    cart_items=CartItem.where(customer_id: current_customer)
    cart_items.each do |cart_item|
      total_price + cart_item.subtotal
    end
    return total_price
  end
  
end
