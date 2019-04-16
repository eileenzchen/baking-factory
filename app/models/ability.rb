class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :customer
      # can read item details
      can :show, Item 

      # can see list of items
      can :index, Item

      # can see their own orders
      can :show, Order do |this_order|
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id 
      end

      # they can read their own data
      can :show, Customer do |this_customer|  
        user.customer == this_customer
      end

      # they can read their own data
      can :update, Customer do |this_customer|  
        user.customer == this_customer
      end

      # they can read their own profile
      can :show, User do |u|  
        u.id == user.id
      end
      
      # they can update their own profile
      can :update, User do |u|  
        u.id == user.id
      end

      # can see list of orders (controller filters automatically)
      can :index, Order

      can :checkout, Order

      can :create, Order

      can :add_to_cart, Order

      # can create an address
      can :create, Address

      # can see their own address
      can :show, Address do |this_address|
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      # they can update their own address
      can :update, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? this_address.id 
      end

      # can see a list of their own addresses (controller filters automatically)
      can :index, Address

    elsif user.role? :baker
      # can read item details
      can :show, Item 

      # can see list of items
      can :index, Item
      
      # can view all orders
      can :index, Order

    elsif user.role? :shipper
      # can read item details
      can :show, Item 

      # can see list of items
      can :index, Item
      
      # can view all orders
      can :index, Order

      # can view order details
      can :show, Order

      # can view address details
      can :show, Address
            
    else
      # guests can read items
      can :index, Item
      can :show, Item

      # guests can become customers
      can :create, Customer
      
    end
  end
end
