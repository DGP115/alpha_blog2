# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'pages#home'

  get 'about', to: 'pages#about'

  resources :articles
  # get 'articles', to: 'articles#index'
  # get 'articles/:id', to: 'articles#show'

  # Routes for User actions
  get 'signup', to: 'users#new'

  # The form_with statement in users/_form.html.erb needs to know where to post
  # the form.  Since we pass it model: @user, it looks for users_path.
  # Since the form is invoked by the "new" method we complete the new user creation
  # by sending the form's data to the create method:
  # post 'users', to: 'users#create'
  # Alternatively, the resources statement assigns all the standard routes.  But we
  # want the "new" method to be invoked by signup [as above] so we can omit it from the
  # resources statement
  resources :users, except: [:new]

  # Routes for Sessions
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
