class SessionsController < ApplicationController
  # Método para criar uma nova sessão (login)
  def create
    # Encontra um usuário pelo email fornecido nos parâmetros.
    user = User.find_by(email: params[:email])
    # Verifica se o usuário foi encontrado e se a senha é válida.
    if user&.valid_password?(params[:password])
      # Retorna um token JWT se a senha for válida
      render json: { token: user.generate_jwt }, status: :created
    else
      # Se as credenciais são erradas, retorna uma mensagem de erro
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
