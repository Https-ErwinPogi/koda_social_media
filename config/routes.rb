Rails.application.routes.draw do
  root to: "posts#index"
  resources :friendships
  resources :friend_requests
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :posts do
    resources :comments, except: :show
  end
  resources :groups
  get 'search_entries/index', as: 'search'
end
