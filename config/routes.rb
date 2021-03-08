Rails.application.routes.draw do
  devise_for :users
  require "sidekiq/web"

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticated do
    root to: 'dashboard#show'
    get '/', to: 'dashboard#show', as: :dashboard
  end

    root to: 'pages#home', as: :root_two

  resources :groups, only: [:show, :new, :create] do
    resources :games, only: [:show, :new, :create]
    resources :user_groups, only: [:index, :create]
  end

  resources :matches, only: [:index]
  resources :games, only: [:show, :new, :create] do
    resources :bingo_cards, only: [:show, :create, :index]
  end

  get "/competition_matches", to: "games#filter", defaults: {format: :json}

  # post '/groups/:id', to: 'groups#add_user'
  # post '/games/:id', to: 'games#join_game'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
