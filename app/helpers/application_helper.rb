module ApplicationHelper

  #Taken from https://gist.github.com/mynameispj/5692162
  def current_class?(test_path)
    return 'active' if request.path == test_path
    ''
  end
  
  def get_address_options(user=nil)
    if user.nil? || user.role?(:admin)
      addresses = Address.active.by_recipient.to_a
    else
      addresses = user.customer.addresses.by_recipient.to_a
    end
    addresses.map{|addr| ["#{addr.recipient} : #{addr.street_1}", addr.id] }
  end
end
