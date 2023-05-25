class AddAccountIdToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :account, index: true
  end
end
