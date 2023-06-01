# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe ::Transaction::Withdraw::Perform, type: :u_case do
  describe '.call' do
    let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100) }
    let(:amount) { 80 }

    subject(:withdraw) { described_class.call(account: account, amount: amount) }

    describe 'success' do
      context 'when the account is open and has enough balance' do
        it 'returns a success' do
          result = withdraw

          expect(result).to be_a_success
          expect(result.type).to eq(:withdraw_transaction_performed)
        end

        it 'creates a withdraw transaction' do
          expect{ withdraw }.to change { Transaction::Record.count }.from(0).to(1)
          expect(Transaction::Record.last.account).to eq(account)
          expect(Transaction::Record.last._type).to eq('withdraw')
          expect(Transaction::Record.last.amount).to eq(80)
        end

        it 'decreases the balance from account' do
          expect { withdraw }.to change { account.balance }.from(100).to(20)
        end
      end
    end

    describe 'failures' do
      context 'when the account is closed' do
        let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100, closed: true) }

        it 'returns a failure' do
          result = withdraw

          expect(result).to be_a_failure
          expect(result.type).to eq(:account_is_closed)
        end
      end

      context 'when the account has not enough balance' do
        let(:amount) { 101 }

        it 'returns a failure' do
          result = withdraw

          expect(result).to be_a_failure
          expect(result.type).to eq(:insufficient_balance)
        end
      end
    end
  end
end