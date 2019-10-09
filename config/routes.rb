Rails.application.routes.draw do
  root 'calculators#info'
  get 'calculate', to: 'calculators#index'
end
