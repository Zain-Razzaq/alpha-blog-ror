# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'home#index'

  resources :blogs do
    collection do
      get 'delete_last_blog', to: 'blogs#delete_last', as: 'delete_last_blog'
    end
  end
  resources :users, only: %i[new create show]
  get 'register', to: 'users#new', as: 'register'
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :categories, only: %i[index show new create destroy]

  mount Sidekiq::Web => '/sidekiq'
end
