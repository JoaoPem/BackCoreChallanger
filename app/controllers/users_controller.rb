class UsersController < ApplicationController
  
  def create
    # Cria uma nova instância de usuário com os parâmetros fornecidos.
    user = User.new(user_params)
    if user.save
      # Se obtiver sucesso, retorna um JSON com o usuário criado.
      render json: user, status: :created
    else
      # Retorna um JSON com o erro.
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # Permite os parâmetros `email`, `password` e `password_confirmation`.
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
