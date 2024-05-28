Rails.application.routes.draw do
  
  devise_for :users, defaults: { format: :json }

  resources :orders
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
end
