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

  resources :jeopardy_games do
    member do
      post 'add_category'
      post 'remove_category'
      post 'add_panel'
      post 'remove_panel'
      patch 'edit_panel'
      post 'add_team'
      post 'remove_team'
      post 'add_score'
      post 'reset_panels'
    end
  end

end
