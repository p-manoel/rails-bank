class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :owner_name, allow_nil: false
      t.decimal :balance, precision: 10, scale: 2, default: 0.0
      t.boolean :closed, default: false

      t.timestamps
    end
  end
end
