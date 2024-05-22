class ApplicationController < ActionController::API
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end

  private

  def authenticate_user!
    render json: { error: 'Você precisa estar autenticado para acessar este recurso.' }, status: :unauthorized unless user_signed_in?
  end
end