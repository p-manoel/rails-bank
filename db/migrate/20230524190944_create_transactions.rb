class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :type, null: false
      t.decimal :amount, precision: 10, scale: 2, allow_nil: false
      t.decimal :fee, precision: 10, scale: 2, default: 0.0, allow_nil: false
      t.integer :receiver_account_id, allow_nil: true

      t.timestamps
    end

    add_reference :transactions, :account, foreign_key: true
  end
end
