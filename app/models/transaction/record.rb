class Transaction::Record < ActiveRecord::Base
  self.table_name = 'transactions'

  belongs_to :account, class_name: '::Account::Record'

  attr_accessible :account, :_type, :amount, :fee, :receiver_account_id

  validates_presence_of :_type, :amount, :fee
  validates_numericality_of :amount, greater_than: 0

  TYPES = {
    deposit: 'deposit',
    withdraw: 'withdraw',
    transfer: 'transfer'
  }.freeze

  validates :_type, inclusion: { in: TYPES.values }
end
