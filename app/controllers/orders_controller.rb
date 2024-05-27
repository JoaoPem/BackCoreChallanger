class OrdersController < ApplicationController
  before_action :authenticate_user!, :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.all
    render json: @orders
  end

  def show
    @order = Order.find(params[:id])
    render json: @order
  end

  def create
    @order = Order.new(order_params)
    
    order_ram = OrderRam.new(order: @order, ram_ids: params[:order][:ram_ids])
    @order.order_ram = order_ram

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    head :no_content
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:processor_id, :motherboard_id, :video_card_id, ram_ids: [])
  end
end