class Account < ActiveRecord::Base
  attr_accessible :owner_name, :balance, :closed

  before_destroy :prevent_destroy

  validates_presence_of :owner_name
  validates_numericality_of :balance, greater_than_or_equal_to: 0

  def deposit(amount)
    return StandardError.new(:account_is_closed) if self.closed

    self.update(balance: self.balance + amount)
  end

  def withdraw(amount)
    return StandardError.new(:account_is_closed) if self.closed
    return StandardError.new(:insufficient_balance) if amount > self.balance

    self.update(balance: self.balance - amount)
  end

  def close!
    self.update(closed: true)
  end

  private

  def prevent_destroy
    raise ActiveRecord::RecordNotDestroyed, "Cannot destroy account"
  end
end
