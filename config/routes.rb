Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  match '/profile/finish_signup', to: 'profile#finish_setup', via: [:get, :patch], as: :finish_signup

  namespace :admin do
    get '/', to: 'videos#index'
    resources :videos, only: [:index]
  end
end
