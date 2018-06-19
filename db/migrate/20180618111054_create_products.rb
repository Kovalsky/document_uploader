class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :sku, null: false
      t.string :supplier_code, null: false
      t.string :name, null: false
      t.decimal :price, null: false
      t.string :field_0
      t.string :field_1
      t.string :field_2
      t.string :field_3
      t.string :field_4

      t.index :sku, unique: true
      t.timestamps
    end

    add_foreign_key :products, :suppliers, column: :supplier_code, primary_key: :code

  end
end
