Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/dashboard', to: 'dashboard#show', as: :dashboard

  resources :games, only: [:show, :new, :create]

  resources :groups, only: [:show, :new, :create] do
    resources :user_groups, only: :create
  end
  # post '/groups/:id', to: 'groups#add_user'
  # post '/games/:id', to: 'games#join_game'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
