# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'home#index'

  resources :blogs, except: [:new, :edit] do
    collection do
      get 'delete_last_blog', to: 'blogs#delete_last', as: 'delete_last_blog'
    end
  end

  resources :users, only: %i[create show] do
    member do
      get 'blogs', to: 'users#user_blogs'
    end
  end

  post '/register', to: 'users#create', as: 'register'
  # get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :categories, except: [:new, :edit]

  mount Sidekiq::Web => '/sidekiq'
end
