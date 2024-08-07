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

  resources :posts do
    patch "publish", on: :member, to: "posts#publish"
  end

  resources :relationships, only: %i(create destroy)
  get "feed", to: "posts#feed"
  resources :reactions, only: %i(create destroy)

  namespace :api do
    namespace :v1 do
      root "static_pages#index"
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"

      resources :relationships, only: %i(create)
      delete "relationships", to: "relationships#destroy"

      patch "posts/:id/publish", to: "posts#publish"
      resources :posts, only: %i(create)
    end
  end
end
