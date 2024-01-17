class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :upc_code
      t.string :product_name
      t.string :brand
      t.string :quantity
      t.string :image_url

      t.timestamps
    end
  end
end
