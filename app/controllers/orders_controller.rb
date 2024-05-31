class OrdersController < ApplicationController

  # Callbacks
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:show, :update, :destroy]

  # Listar todos os pedidos do usuário autenticado
  def index
    # Obtém todos os pedidos do usuário atual
    @orders = current_user.orders
    # Renderiza os pedidos em formato JSON
    render json: @orders
  end

  # Exibir um pedido específico do usuário autenticado
  def show
    # Renderiza o pedido específico em formato JSON
    render json: @order
  end

  # Novo pedido para o usuário autenticado
  def create
    # Inicializa um novo pedido com parâmetros permitidos
    @order = current_user.orders.build(order_params)
    if @order.save
      # Renderiza o pedido criado em formato JSON com status de criado
      render json: @order, status: :created
    else
      # Renderiza os erros com status de entidade não processável
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # Atualizar um pedido existente do usuário autenticado
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # Excluir um pedido existente do usuário autenticado
  def destroy
    # Exclui o pedido
    @order.destroy
    head :no_content
  end

  private

  # Encontrar e definir a instância do pedido
  def set_order
    # Define a instância @order com base no parâmetro :id
    @order = Order.find(params[:id])
  end

  # Autorizar o usuário para garantir que ele só possa acessar, atualizar ou excluir seus próprios pedidos
  def authorize_user
    # Se o user_id do pedido não corresponder ao id do usuário atual, retorna status 403 (Forbidden)
    head :forbidden unless @order.user_id == current_user.id
  end

  # Define quais parâmetros são permitidos para criar e atualizar um pedido
  def order_params
    # Permite apenas os parâmetros especificados para evitar atribuição massiva de outros atributos
    params.require(:order).permit(:processor_id, :motherboard_id, :video_card_id, ram_ids: [])
end
