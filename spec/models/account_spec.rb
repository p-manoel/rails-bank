# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe Account, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:owner_name) }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }  
  end

  describe '.deposit' do
    describe 'success' do
      context 'when the account is open' do
        let(:account) { Account.create(owner_name: 'John Doe', balance: 100, closed: false) }

        it 'increases the balance' do
          expect { account.deposit(100) }.to change { account.balance }.from(100).to(200)
        end
      end
    end

    describe 'failures' do
      context 'when the account is closed' do
        let(:account) { Account.create(owner_name: 'John Doe', balance: 100, closed: true) }
  
        it 'returns an error' do
          result = account.deposit(100)
  
          expect(result).to be_a(StandardError)
          expect(result.message).to eq('account_is_closed')
        end
      end
    end
  end

  describe '.withdraw' do
    describe 'success' do
      context 'when the account is open and have enough balance' do
        let(:account) { Account.create(owner_name: 'John Doe', balance: 100, closed: false) }

        it 'decreases the balance' do
          expect { account.withdraw(50) }.to change { account.balance }.from(100).to(50)
        end
      end
    end

    describe 'failures' do
      context 'when the account is closed' do
        let(:account) { Account.create(owner_name: 'John Doe', balance: 100, closed: true) }
  
        it 'returns an error' do
          result = account.withdraw(10)
  
          expect(result).to be_a(StandardError)
          expect(result.message).to eq('account_is_closed')
        end

        it 'does not change the balance' do
          expect { account.withdraw(10) }.not_to change { account.balance }
        end
      end

      context 'when the account does not have enough balance' do
        let(:account) { Account.create(owner_name: 'John Doe', balance: 100, closed: false) }

        it 'returns an error' do
          result = account.withdraw(200)

          expect(result).to be_a(StandardError)
          expect(result.message).to eq('insufficient_balance')
        end

        it 'does not change the balance' do
          expect { account.withdraw(200) }.not_to change { account.balance }
        end
      end
    end
  end

  describe '.close!' do
    let(:account) { Account.create(owner_name: 'John Doe', balance: 100, closed: false) }

    it 'closes the account' do
      expect { account.close! }.to change { account.closed }.from(false).to(true)
    end
  end

  describe '.destroy' do
    let(:account) { Account.create(owner_name: 'John Doe', balance: 100, closed: false) }

    it 'raises an error' do
      expect { account.destroy }.to raise_error(ActiveRecord::RecordNotDestroyed)
    end
  end
end
