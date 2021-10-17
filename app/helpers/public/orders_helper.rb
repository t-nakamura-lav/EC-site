module Public::OrdersHelper

  #追加メソッド
  # 小計
  def sub_price(sub)
    sub.item.price * sub.amount
  end

  # 合計
  def total_price(totals)
    price = 0
    totals.each do |total|
      price += sub_price(total)
    end
    return price
  end
end
