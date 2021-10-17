class ChangeColumnToNotNull < ActiveRecord::Migration[5.2]
  def up
    change_column :order_details, :order_id,:integer, null: true
    change_column :order_details, :item_id,:integer, null: true
    change_column :order_details, :amount,:integer, null: true
    change_column :order_details, :price,:integer, null: true
  end

  def down
    change_column :order_details, :order_id,:integer, null: false
    change_column :order_details, :item_id,:integer, null: false
    change_column :order_details, :amount,:integer, null: false
    change_column :order_details, :price,:integer, null: false
  end
end
