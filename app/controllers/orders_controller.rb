class OrdersController < ApplicationController

  # Autenticação do usuário e configura a ordem antes de algumas ações específicas.
  before_action :authenticate_user!, :set_order, only: [:show, :update, :destroy]

  # Listar todas as order.
  def index
    @orders = Order.all
    render json: @orders
  end

  # Exibi uma ordem específica.
  def show
    @order = Order.find(params[:id])
    render json: @order
  end

  def create
    # Cria uma nova instância de Order com os parâmetros fornecidos
    @order = Order.new(order_params)
    
    # Cria uma nova instância de OrderRam associada à nova Order, usando os IDs de RAM fornecidos nos parâmetros
    order_ram = OrderRam.new(order: @order, ram_ids: params[:order][:ram_ids])
    @order.order_ram = order_ram

    # Retorna um JSON com a ordem criada
    if @order.save
      render json: @order, status: :created, location: @order
    else
      # Retorna um JSON com o error
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def update
    # Encontra a ordem específica pelo ID fornecido nos parâmetros
    @order = Order.find(params[:id])
    # Tenta atualizar a ordem com os novos parâmetros e verifica se foi bem-sucedido retornando um JSON
    if @order.update(order_params)
      render json: @order
    else
      # Se a ordem não foi atualizada, retorna um JSON com o erro
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    # Resposta sem conteúdo
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