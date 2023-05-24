# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe ::Account::Deposit, type: :model do
  describe '.call' do
    subject(:deposit) { described_class.call(account: account, amount: 100) }

    describe 'success' do
      context 'when the account is open' do
        let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100, closed: false) }

        it 'returns a success' do
          result = deposit

          expect(result).to be_a_success
          expect(result.type).to eq(:amount_deposited)
        end

        it 'increases the balance' do
          expect { deposit }.to change { account.balance }.from(100).to(200)
        end
      end
    end

    describe 'failures' do
      context 'when the account is closed' do
        let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100, closed: true) }
  
        it 'returns an error' do
          result = deposit
  
          expect(result).to be_a_failure
          expect(result.type).to eq(:account_is_closed)
        end
      end
    end
  end
end