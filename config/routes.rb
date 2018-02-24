Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :admin do
    resources :videos, only: [:index]
  end
end
