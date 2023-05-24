# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe ::Account::Close, type: :model do
  describe '.call' do
    let(:account) { Account::Record.create(owner_name: 'John Doe', balance: 100, closed: false) }

    subject(:close) { described_class.call(account: account) }

    describe 'success' do
      it 'returns a success' do
        result = close

        expect(result).to be_a_success
        expect(result.type).to eq(:account_closed)
      end

      it 'closes the account' do
        expect { close }.to change { account.closed }.from(false).to(true)
      end
    end
  end
end