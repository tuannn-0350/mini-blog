Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  root "static_pages#index"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  resources :users do
    resources :posts
    member do
      get :following, :followers
    end
  end

  resources :posts
  resources :relationships, only: %i(create destroy)
  get "feed", to: "posts#feed"
  resources :reactions, only: %i(create destroy)
end
