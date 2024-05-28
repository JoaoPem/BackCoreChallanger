class ApplicationController < ActionController::API

  # Configura o controlador para responder com JSON por padrão.
  respond_to :json

  # Se o controlador for um controlador Devise executará o "configure_permitted_parameters".
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  # Método para configurar parâmetros permitidos para Devise.
  def configure_permitted_parameters
    # Parâmetros `email`, `password` e `password_confirmation`durante o registro de usuário.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end

  private
  # Se o usuário não estiver autenticado, retorna uma mensagem de erro JSON com status
  def authenticate_user!
    render json: { error: 'Você precisa estar autenticado para acessar este recurso.' }, status: :unauthorized unless user_signed_in?
  end
end