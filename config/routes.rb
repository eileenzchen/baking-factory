Rails.application.routes.draw do

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  #cart routes
  get 'cart/view', to: 'cart#show', as: :view_cart
  get 'cart/checkout', to: 'cart#checkout', as: :checkout
  get 'cart/:id/add_item', to: 'cart#add_item', as: :add_item
  get 'cart/:id/remove_item', to: 'cart#remove_item', as: :remove_item
  get 'cart/empty_cart', to: 'cart#empty_cart', as: :empty_cart
  # post 'cart/update_quantity', to: 'cart#update_quantity', as: :update_quantity

  

  # Authentication routes
  resources :sessions
  resources :users
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Routes for main resources
  get 'place_order', to: 'orders#create', as: :place_order
  patch 'order_items/:id/toggle_shipped', to: 'order_items#toggle_shipped', as: :toggle_shipped
  patch 'customers/:id/toggle_customer', to: 'customers#toggle_customer', as: :toggle_customer
  patch 'items/:id/toggle_item', to: 'items#toggle_item', as: :toggle_item
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :order_items

  #Routes for item prices
  get 'items_prices/new', to: 'item_prices#new', as: :new_item_price
  post 'item_prices', to: 'item_prices#create', as: :item_prices
  
  # Set the root url
  root :to => 'home#home'
  
end
