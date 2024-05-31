Rails.application.routes.draw do
  # Configura as rotas para a autenticação do Devise
  devise_for :users, defaults: { format: :json }

  # Rotas RESTful para os controladores
  resources :orders, only: [:index, :show, :create, :update, :destroy]
  resources :admin_orders, controller: 'admin_order', only: [:index, :show, :create, :update, :destroy]
  
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
end