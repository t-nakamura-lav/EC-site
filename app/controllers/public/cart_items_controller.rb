class Public::CartItemsController < ApplicationController

  def index
    @cart_items=CartItem.where(customer_id: current_customer)
    @cart_item=CartItem.new
  end

  # 商品変更
  def update
    @cart_items=CartItem.where(customer_id: current_customer)
    @cart_item=CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to public_cart_items_path
    else
      render "index"
    end
  end

  # items/show カートに入れるボタン
  def create
    @cart_item = current_customer.cart_items.new(cart_item_params)
    if @cart_item.amount.nill?
      @cart_item.save
      flash[:notice] = "カートに追加しました"
      redirect_to public_cart_items_path
    else
      flash[:notice] = "カートに商品を入れてください"
      redirect_to public_item_path(@cart_item.item)
    end
  end

  # 商品を１つ削除
  def destroy
    @cart_item=CartItem.find(params[:id])
    @cart_item.destroy
    @cart_items=CartItem.where(customer_id: current_customer)
  end

  # カート内商品を全て削除
  def destroy_all
    cart_items=CartItem.where(customer_id: current_customer)
    @cart_item=CartItem.new
    cart_items.each do |cart_item|
      cart_item.destroy
    end
    @cart_items=CartItem.where(customer_id: current_customer)
  end


  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end

end
