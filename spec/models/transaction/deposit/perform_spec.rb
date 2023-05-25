# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe ::Transaction::Deposit::Perform, type: :u_case do
  describe '.call' do
    subject(:deposit) { described_class.call(account: account, amount: amount) }

    describe 'success' do
      context 'when the account is open' do
        let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100) }
        let(:amount) { 100 }

        it 'returns a success' do
          result = deposit

          expect(result).to be_a_success
          expect(result.type).to eq(:deposit_transaction_performed)
        end

        it 'creates a deposit transaction' do
          expect { deposit }.to change { Transaction::Record.count }.from(0).to(1)
          
          expect(Transaction::Record.last._type).to eq('deposit')
          expect(Transaction::Record.last.account).to eq(account)
          expect(Transaction::Record.last.amount).to eq(100)
        end

        it 'increases the balance' do
          expect { deposit }.to change { account.balance }.from(100).to(200)
        end
      end
    end

    describe 'failures' do
      context 'when the account is closed' do

      end
    end
  end
end