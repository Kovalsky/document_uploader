class CreateSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers do |t|
      t.string :code
      t.string :name

      t.index :code, unique: true
      t.timestamps
    end
  end
end
