class Public::OrdersController < ApplicationController

  def new
    @order=Order.new
    @address=Address.new
  end

  def to_log
    @cart_items=CartItem.where(customer_id:current_customer.id)
    @order=Order.new(order_params)
    @shipping_sel=order_params[:shipping_sel]
    @shipping_address_id=order_params[:shipping_address_id]
    # 配送先（0：自宅、1:既存配送先、2:新規配送先）
    if @shipping_sel == "0"
      @shipping_address=ShippingAddress.new
    elsif @shipping_sel == "1"
      @shipping_address=ShippingAddress.find(@shipping_address_id)
    else
      @shipping_address=ShippingAddress.new(shipping_address_params[:shipping_address])
      @shipping_address.customer_id=current_customer.id
      render :information if @shipping_address.invalid?
    end
  end

  def create
    # 新規の場合配送先登録
    @shipping_sel=order_params[:shipping_sel]
    @shipping_address_id=order_params[:shipping_address_id]
    if @shipping_sel == "2"
      @shipping_address=ShippingAddress.new(shipping_address_params[:shipping_address])
      @shipping_address.customer_id=current_customer.id
      render :information and return if params[:back] || !@shipping_address.save
      @shipping_address_id=@shipping_address.id.to_s
    else
      @shipping_address=ShippingAddress.new
    end
    # オーダー情報登録
    @order = Order.new(order_params)
    @order.total_price = 0
    if @shipping_sel == "0"
      @order.postcode = Customer.find(current_customer.id).postcode
      @order.address = Customer.find(current_customer.id).address
      @order.address_name = Customer.find(current_customer.id).join_name
    else
      @shipping_address=ShippingAddress.find(@shipping_address_id)
      @order.postcode = @shipping_address.postcode
      @order.address = @shipping_address.address
      @order.address_name = @shipping_address.address_name
    end
    render :information and return if params[:back] || !@order.save
    # オーダー詳細登録
    total_price = 0
    @cart_items=CartItem.where(customer_id: current_customer.id)
    @cart_items.each do |cart_item|
      @order_detail=OrderDetail.new
      @order_detail.order_id=@order.id
      @order_detail.item_id=cart_item.item_id
      @order_detail.quantity=cart_item.quantity
      @order_detail.price=Item.find(@order_detail.item_id).tax_include * cart_item.quantity
      @order_detail.save
      cart_item.destroy
      total_price += @order_detail.price
    end
    #商品合計アップデート
    @order.total_price = total_price
    @order.save
    redirect_to thankyou_orders_path
  end

  def index
    @orders = Order.where(customer_id: current_customer.id).order(id: :desc)
    #注文商品一覧を作成
    @order_details = []
    @orders.each do |order|
      @order_details.push(order.detail_items)
    end
  end

  def show
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(order_id: @order.id)
  end

  def thanx
  end

  private

  def order_params
    params.require(:order).permit(:payment_method,:shipping_sel,:shipping_address_id).merge(customer_id: current_customer.id ,postage: 800)
  end

  def address_params
    params.require(:address).permit(address:[:postcode, :address, :address_name])
  end


end
