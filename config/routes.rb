Rails.application.routes.draw do
  root to: 'pages#index'

  resources :events, only: [:index] do
    collection do
      get '/history', to: 'events#history'
    end
  end

  get 'googleauth/start', to: 'google_auth#start'
  get 'googleauth/callback', to: 'google_auth#callback'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :account, only: [:index] do
    collection do
      match '/finish_signup', to: 'account#finish_setup', via: [:get, :patch], as: 'finish_signup'
      get '/access_tokens/new', to: 'access_tokens#new'
      post '/access_tokens', to: 'access_tokens#create'
      delete '/access_tokens/:id', to: 'access_tokens#destroy'
      get '/recordings', to: 'account#recordings'
    end
  end

  namespace :api, defaults: {format: :json} do
    resources :recordings, only: [:create]
  end

  namespace :admin do
    get '/', to: 'presentations#index'
    resources :presentations do
      collection do
        post '/from_youtube', to: 'presentations#create_from_youtube'
      end
    end
    resources :recordings, only: [:index]
    resources :events, only: [:index, :edit, :update, :new, :create] do
      collection do
        get '/history', to: 'events#history'
      end
    end
  end
end
