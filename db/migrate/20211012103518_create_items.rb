class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "name"
      t.text "introduction"
      t.string "image_id"
      t.integer "price"
      t.integer "genre_id"
      t.boolean "is_active"
      
      t.timestamps
    end
  end
end
