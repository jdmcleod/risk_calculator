Rails.application.routes.draw do
  root 'sessions#new'
  get 'sessions/new'

  get 'users/new'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get     '/info',   to: 'calculators#info'

  resources :calculators do
    member do
      post 'roll'
      patch 'undo'
      patch 'clear'
      patch 'remove_player'
      get 'load'
      patch 'add_player'
    end
  end

  resources :jeopardy_games

end
