class ChangeColumnToNull < ActiveRecord::Migration[5.2]
  def up
    change_column :orders, :postcode,:integer, null: true
    change_column :orders, :payment_method,:integer, null: true
  end

  def down
    change_column :orders, :postcode,:integer, null: false
    change_column :orders, :payment_method,:integer, null: false
  end
end
