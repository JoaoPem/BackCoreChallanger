class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Associações usuário tem n pedidos
  has_many :orders

  devise :database_authenticatable, 
  :registerable,
  :recoverable, 
  :rememberable, 
  :validatable,
  :jwt_authenticatable, 
  jwt_revocation_strategy: JwtDenylist

  # Método para gerar um token JWT para o usuário
  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end
  
  
end
