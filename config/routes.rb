Rails.application.routes.draw do

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  #cart routes
  get 'carts/view', to: 'carts#show', as: :view_cart
  get 'carts/checkout', to: 'carts#checkout', as: :checkout
  get 'carts/:id/add_item', to: 'carts#add_item', as: :add_item
  get 'carts/:id/remove_item', to: 'carts#remove_item', as: :remove_item
  get 'carts/empty_cart', to: 'carts#empty_cart', as: :empty_cart
  # post 'carts/update_quantity', to: 'carts#update_quantity', as: :update_quantity

  # get 'items/:id/toggle, to: 'items#toggle', as: :toggle_item

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
  resources :order_items

  # Routes for order items and item prices
  # get 'item_prices/new', to: 'items#new_price', as: :new_item_price
  # post 'item_prices', to: 'items#create_price', as: :item_prices
  
  # Set the root url
  root :to => 'home#home'
  
end
