class AddUserToAccounts < ActiveRecord::Migration
  def change
    add_belongs_to :accounts, :user
  end
end
