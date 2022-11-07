Rails.application.routes.draw do
  #resources :messages
  
  resources :conversations do
    resources :messages
  end
  resources :products
  resources :users, only: [:show, :edit, :update]
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "products#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
