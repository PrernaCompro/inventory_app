class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string  :name, null: false
      t.string  :sku
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :quantity, default: 0, null: false
      t.boolean :active, default: true, null: false

      t.references :supplier, null: false, foreign_key: { on_delete: :nullify }

      t.timestamps
    end

    add_index :products, :sku, unique: true
  end
end
