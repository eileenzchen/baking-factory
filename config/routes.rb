Rails.application.routes.draw do

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  # Authentication routes
  resources :sessions
  resources :users
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items

  # Routes for order items and item prices
  get 'order_items/new', to: 'order_items#new', as: :new_medicine_cost
  get 'item_prices/new', to: 'item_prices#new', as: :new_procedure_cost
  post 'order_items', to: 'order_items#create', as: :order_items
  post 'item_prices', to: 'item_prices#create', as: :item_prices
  
  # Set the root url
  root :to => 'home#home'
  
end
