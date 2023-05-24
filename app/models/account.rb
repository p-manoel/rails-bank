class Account < ActiveRecord::Base
  attr_accessible :owner_name, :balance, :closed

  def deposit(amount)
    self.balance += amount
    save!
  end

  def withdraw(amount)
    self.balance -= amount
    save!
  end

  def close!
    self.closed = true
    save!
  end
end
