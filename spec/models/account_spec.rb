# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe Account, type: :model do
  describe '#deposit' do
    it 'increases the balance' do
      account = Account.new(owner_name: 'John Doe', balance: 100, closed: false)
      account.deposit(50)
      expect(account.balance).to eq(150)
    end
  end

  describe '#withdraw' do
    it 'decreases the balance' do
      account = Account.new(owner_name: 'John Doe', balance: 100, closed: false)
      account.withdraw(50)
      expect(account.balance).to eq(50)
    end
  end

  describe '#close!' do
    it 'sets the account as closed' do
      account = Account.new(owner_name: 'John Doe', balance: 100, closed: false)
      account.close!
      expect(account.closed).to be true
    end
  end
end
