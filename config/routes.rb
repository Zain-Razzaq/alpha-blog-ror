# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  resources :blogs
  resources :users, only: %i[new create show]
  get 'register', to: 'users#new', as: 'register'
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
end
