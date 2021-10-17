class Public::OrdersController < ApplicationController

  def new
    @order = Order.new
    @address = Address.new
  end

  def to_log
    @orders = Order.all
    @order = Order.new(order_params)
    @postage = 800 
    # 配送先(0:自宅)
    if params[:order][:address_status] == "0"
      @order.postcode = current_customer.postcode
      @order.address = current_customer.address
      @order.address_name = current_customer.name
    # 配送先(1:既存配送先)
    elsif params[:order][:address_status] == "1"
      @address = Address.find(params[:order][:address_id])
      @order.postcode = @address.postcode
      @order.address = @address.address
      @order.address_name = @address.address_name
    # 配送先(2:新規配送先)
    elsif params[:order][:address_status] == "2"
      @order.postcode = params[:order][:postcode]
      @order.address = params[:order][:address]
      @order.address_name = params[:order][:address_name]
    #カスタマーの住所登録と入力内容の確認
      @address = current_customer.addresses.build
      @address.postcode = params[:order][:postcode]
      @address.address = params[:order][:address]
      @address.address_name = params[:order][:address_name]
      @address.save
    end
    @cart_items = current_customer.cart_items
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.total_price = params[:order][:total_price]
    @order.save
    @cart_items = current_customer.cart_items
    @cart_items.each do |cart_item|
      OrderDetail.create(
        item_id: cart_item.item.id,
        order_id: @order.id,
        amount: cart_item.amount,
      )
    end
    @cart_items.destroy_all
    redirect_to thanx_public_orders_path
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
    params.require(:order).permit(:address, :postcode, :address_name, :payment_method, :total_price, :postage)
  end


end
