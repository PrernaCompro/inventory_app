class CreateSuppliers < ActiveRecord::Migration[7.2]
  def change
    create_table :suppliers do |t|
      t.string  :name,  null: false
      t.string  :email
      t.string  :phone
      t.text    :address
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :suppliers, :email, unique: true
    add_index :suppliers, :name
    add_index :suppliers, :active
    add_index :suppliers, [:active, :name]
    add_index :suppliers, :phone
  end
end
