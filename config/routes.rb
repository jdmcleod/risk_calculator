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

  resources :calculators do
    get 'load'
  end

end
