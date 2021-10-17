class ChangeColumnToAllowNull < ActiveRecord::Migration[5.2]
  def up
    change_column :orders, :postage,:integer, null: true
  end

  def down
    change_column :orders, :postage,:integer, null: false
  end
end
