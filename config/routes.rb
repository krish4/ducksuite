Ducksuite::Application.routes.draw do

  get "widget/preview/:widget_type/:album_id", to: "widget#preview"
  get "widget(/:widget_type)(/:album_id)",     to: "widget#index"
  post '/instagram/subscription_callback'

  devise_for :users

  namespace :api, defaults: { format: :json } do

    resources :users do
      member do
        post '/instagram/auth', to: :authenticate
        get :info
        post :open
        post :close
      end
    end

    namespace :instagram do
      resources :users, only: [:show]
    end

    resources :domains, only: [:create, :destroy]

    resources :albums do
      resources :pictures, only: [:index, :show, :destroy] do
        member do
          post :accept
          post :deny
        end
        collection do
          post :accept_all 
          post :deny_all
          get  :fetch_old_instagram_pictures
          get  :fetch_new_instagram_pictures
          get  :inbox_pictures
        end
      end
    end

  end

  root 'home#index'
  get '*path', to: 'home#index'
  # Do not add any routes below as they will be overwritten by the '*path' route.
end
