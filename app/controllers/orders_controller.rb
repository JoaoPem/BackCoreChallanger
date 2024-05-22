class OrdersController < ApplicationController

  before_action :authenticate_user!, :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.all
    render json: @orders
  end

  # def index
  #   @orders = Order.all
  #   orders_with_products = @orders.map do |order|
  #     {
  #       id: order.id,
  #       processor: order.processor&.name,
  #       motherboard: order.motherboard&.name,
  #       ram: order.ram&.name,
  #       video_card: order.video_card&.name,
  #       created_at: order.created_at,
  #       updated_at: order.updated_at
  #     }
  #   end
  #   render json: orders_with_products
  # end

  def show
    @order =  Order.find(params[:id])
    render json: @order
  end

  def create
    @order = Order.new(order_params)
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
    params.require(:order).permit(:processor_id, :motherboard_id, :ram_id, :video_card_id)
  end
end
