class AddDefaultValuetoActive < ActiveRecord::Migration[5.1]
  def change
    change_column_default :addresses, :is_billing, false
    change_column_default :addresses, :active, true
    change_column_default :customers, :active, true
    change_column_default :items, :active, true
    change_column_default :users, :active, true
  end
end
