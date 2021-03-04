Rails.application.routes.draw do
  devise_for :users
  root to: 'dashboard#show'
  get '/', to: 'dashboard#show', as: :dashboard

  resources :groups, only: [:show, :new, :create] do
    resources :games, only: [:show, :new, :create]
    resources :user_groups, only: [:index, :create]
    resources :bingo_cards, only: [:show]
  end
  resources :matches, only: [:index]
  # post '/groups/:id', to: 'groups#add_user'
  # post '/games/:id', to: 'games#join_game'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
