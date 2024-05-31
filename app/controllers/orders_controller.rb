class OrdersController < ApplicationController
  # Autenticação do usuário e configura a ordem antes de algumas ações específicas.
  # before_action :authenticate_user!, except: [:index]
  before_action :set_order, only: [:show, :update, :destroy]

  # Listar todas as orders.
  def index
    @orders = Order.includes(:processor, :motherboard, :video_card, :order_rams).all

    # Ordenação
    if params[:sort_by].present?
      @orders = @orders.order(params[:sort_by])
    end

    # Filtragem por user_id
    if params[:user_id].present?
      @orders = @orders.where(user_id: params[:user_id])
    end

    # Filtragem por order_id
    if params[:order_id].present?
      @orders = @orders.where(id: params[:order_id])
    end

    render json: @orders.to_json(include: {
      processor: { only: [:id, :name] },
      motherboard: { only: [:id, :name] },
      video_card: { only: [:id, :name] },
      order_rams: { include: { rams: { only: [:id, :name] } } }
    })
  end

  # Exibir uma ordem específica.
  def show
    render json: @order.to_json(include: {
      processor: { only: [:id, :name] },
      motherboard: { only: [:id, :name] },
      video_card: { only: [:id, :name] },
      order_rams: { include: { rams: { only: [:id, :name] } } }
    })
  end

  # Criar uma nova ordem.
  def create
    @order = Order.new(order_params)

    if @order.save
      ram_ids = params[:order][:ram_ids]
      ram_ids.each do |ram_id|
        order_ram = OrderRam.create(ram_ids: [ram_id])
        OrderOrderRam.create(order: @order, order_ram: order_ram)
      end
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # Atualizar uma ordem existente.
  def update
    if @order.update(order_params)
      @order.order_rams.destroy_all
      ram_ids = params[:order][:ram_ids]
      ram_ids.each do |ram_id|
        order_ram = OrderRam.create(ram_ids: [ram_id])
        OrderOrderRam.create(order: @order, order_ram: order_ram)
      end
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # Excluir uma ordem existente.
  def destroy
    @order.destroy
    head :no_content
  end

  private

  # Encontrar e definir a instância da ordem
  def set_order
    @order = Order.find(params[:id])
  end

  # Define quais parâmetros são permitidos para criar e atualizar uma ordem
  def order_params
    params.require(:order).permit(:processor_id, :motherboard_id, :video_card_id, ram_ids: [])
  end
end
