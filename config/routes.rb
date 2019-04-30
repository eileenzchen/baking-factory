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
  get "admin/dashboard", to: 'users#admin_dashboard', as: :admin_dashboard
  get "customers/:id/dashboard", to: 'customers#dashboard', as: :customer_dashboard
  get "shipper/dashboard", to: 'users#shipper_dashboard', as: :shipper_dashboard
  get "baker/dashboard", to: 'users#baker_dashboard', as: :baker_dashboard


  resources :addresses
  resources :customers
  resources :orders
  resources :items

  # Routes for order items and item prices
  get 'cart', to: 'order_items#edit', as: :view_cart
  # get 'checkout', to: 'order_items#create', as: :
  get 'item_prices/new', to: 'item_prices#new', as: :new_item_price
  post 'item_prices', to: 'item_prices#create', as: :item_prices
  
  # Set the root url
  root :to => "users#admin_dashboard", :constraints => {current_user: "admin"}
  root :to => "customers#dashboard", :constraints => {current_user: "customer"}
  
  root :to => "users#shipper_dashboard", :constraints => {current_user: "shipper"}
  root :to => "users#baker_dashboard", :constraints => {current_user: "baker"}
  root :to => 'home#home'
  
end
