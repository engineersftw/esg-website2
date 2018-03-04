Rails.application.routes.draw do
  root to: 'pages#index'

  resources :events, only: [:index] do
    collection do
      get '/history', to: 'events#history'
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :account, only: [:index] do
    collection do
      match '/finish_signup', to: 'account#finish_setup', via: [:get, :patch], as: 'finish_signup'
      get '/access_tokens/new', to: 'access_tokens#new'
      post '/access_tokens', to: 'access_tokens#create'
      delete '/access_tokens/:id', to: 'access_tokens#destroy'
    end
  end

  namespace :api, defaults: {format: :json} do
    resources :recordings, only: [:create]
  end

  namespace :admin do
    get '/', to: 'videos#index'
    resources :videos, only: [:index]
  end
end
