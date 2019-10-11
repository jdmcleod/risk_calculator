Rails.application.routes.draw do
  root 'calculators#info'
  get 'calculate', to: 'calculators#index'
  get 'new', to: 'calculators#new'
  get 'load', to: 'calculators#load'
end
