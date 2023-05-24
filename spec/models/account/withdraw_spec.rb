# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe ::Account::Withdraw, type: :model do
  describe '.call' do
    subject(:withdraw) { described_class.call(account: account, amount: amount) }

    describe 'success' do
      context 'when the account is open and have enough balance' do
        let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100, closed: false) }
        let(:amount) { 50 }

        it 'decreases the balance' do
          expect { withdraw }.to change { account.balance }.from(100).to(50)
        end
      end
    end

    describe 'failures' do
      context 'when the account is closed' do
        let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100, closed: true) }
        let(:amount) { 50 }

        it 'returns an error' do
          result = withdraw
  
          expect(result).to be_a_failure
          expect(result.type).to eq(:account_is_closed)
        end

        it 'does not change the balance' do
          expect { withdraw }.not_to change { account.balance }
        end
      end

      context 'when the account does not have enough balance' do
        let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100, closed: false) }
        let(:amount) { 200 }

        it 'returns an error' do
          result = withdraw

          expect(result).to be_a_failure
          expect(result.type).to eq(:insufficient_balance)
        end

        it 'does not change the balance' do
          expect { withdraw }.not_to change { account.balance }
        end
      end
    end
  end
end