Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :games, only: [:show, :new, :create]
  resources :groups, only: [:show, :new, :create]
  post '/groups/:id', to: 'groups#add_user'
  post '/games/:id', to: 'games#join_game'
  get '/dashboard', to: 'pages#dashboard', as: :dashboard
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
