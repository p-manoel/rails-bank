class Account::Record < ActiveRecord::Base
  self.table_name = 'accounts'

  has_many :transactions, class_name: 'Transaction::Record', foreign_key: :account_id

  attr_accessible :owner_name, :balance, :closed

  before_destroy :prevent_destroy

  validates_presence_of :owner_name
  validates_numericality_of :balance, greater_than_or_equal_to: 0

  private

  def prevent_destroy
    raise ActiveRecord::RecordNotDestroyed, "Cannot destroy account"
  end
end
