# spec/models/account_spec.rb

require 'spec_helper'

RSpec.describe ::Transaction::Transfer::Perform, type: :u_case do
  describe '.call' do
    let(:sender_account) { Account::Record.create(owner_name: 'Jonny Deep', balance: 2000) }
    let(:receiver_account) { Account::Record.create(owner_name: 'John Doe', balance: 0) }
    let(:amount) { 100 }

    subject(:transfer) { described_class.call(amount: amount, sender_account: sender_account, receiver_account: receiver_account) }

    describe 'success' do
      context 'when the both accounts are opened and has enough balance' do
        context 'and the moment of the transfer is a business hours' do
          let(:moment_at_a_business_hours) { Time.new('2023', '01', '02', '10', '00') } # it's a Monday at 10:00 AM

          before { allow(Time).to receive(:current).and_return(moment_at_a_business_hours) }

          it 'returns a success' do
            result = transfer

            expect(result).to be_a_success
            expect(result.type).to eq(:transfer_transaction_performed)
          end

          it 'creates a transfer transaction with a fee of 5' do
            expect{ transfer }.to change { ::Transaction::Record.count }.from(0).to(1)

            created_transaction = ::Transaction::Record.last

            expect(created_transaction.account).to eq(sender_account)
            expect(created_transaction._type).to eq('transfer')
            expect(created_transaction.fee.to_i).to eq(5)
            expect(created_transaction.amount.to_i).to eq(amount)
            expect(created_transaction.receiver_account_id).to eq(receiver_account.id)
          end

          it 'decreses the sender account balance' do
            expect { transfer }.to change { sender_account.reload.balance }.from(2000).to(1895)
          end

          it 'increases the receiver account balance' do
            expect { transfer }.to change { receiver_account.reload.balance }.from(0).to(100)
          end

          context 'when amount is above 1000' do
            let(:amount) { 1001 }

            it 'creates a transfer with an aditional fee of 10' do
              expect{ transfer }.to change { ::Transaction::Record.count }.from(0).to(1)

              created_transaction = ::Transaction::Record.last

              expect(created_transaction.account).to eq(sender_account)
              expect(created_transaction._type).to eq('transfer')
              expect(created_transaction.fee.to_i).to eq(5 + 10)
              expect(created_transaction.amount.to_i).to eq(amount)
              expect(created_transaction.receiver_account_id).to eq(receiver_account.id)
            end
          end
        end

        context 'and the moment of the transfer is not a business hours' do
          let(:moment_at_a_not_business_hours) { Time.new('2023', '01', '01', '10', '00') } # it's a Sunday at 10:00 AM

          before { allow(Time).to receive(:current).and_return(moment_at_a_not_business_hours) }

          it 'returns a success' do
            result = transfer
  
            expect(result).to be_a_success
            expect(result.type).to eq(:transfer_transaction_performed)
          end

          it 'creates a transfer transaction with fee of 7' do
            expect{ transfer }.to change { Transaction::Record.count }.from(0).to(1)

            created_transaction = ::Transaction::Record.last

            expect(created_transaction.account).to eq(sender_account)
            expect(created_transaction._type).to eq('transfer')
            expect(created_transaction.amount.to_i).to eq(amount)
            expect(created_transaction.fee.to_i).to eq(7)
            expect(created_transaction.receiver_account_id).to eq(receiver_account.id)
          end

          it 'decreases them balance from sender account' do
            expect{ transfer }.to change { sender_account.balance }.from(2000).to(1893)
          end

          it 'increases the balance from receiver account' do
            expect { transfer }.to change { receiver_account.balance }.from(0).to(100)
          end

          context 'when amount is above 1000' do
            let(:amount) { 1001 }

            it 'creates a transfer with an aditional fee of 10' do
              expect{ transfer }.to change { ::Transaction::Record.count }.from(0).to(1)

            created_transaction = ::Transaction::Record.last

            expect(created_transaction.account).to eq(sender_account)
            expect(created_transaction._type).to eq('transfer')
            expect(created_transaction.fee.to_i).to eq(17)
            expect(created_transaction.amount.to_i).to eq(amount)
            expect(created_transaction.receiver_account_id).to eq(receiver_account.id)
            end

            it 'decreases the balance from the sender account' do
              expect { transfer }.to change { sender_account.balance.to_i }.from(2000).to(982)
            end

            it 'increases the balance from the receiver account' do
              expect { transfer }.to change { receiver_account.balance.to_i }.from(0).to(1001)
            end
          end
        end
      end
    end

    describe 'failures' do
      context 'when sender account is closed' do
        let(:sender_account) { Account::Record.create(owner_name: 'Jonny Deep', balance: 2000, closed: true) }

        it 'returns a failure' do
          result = transfer

          expect(result).to be_a_failure
          expect(result.type).to eq(:sender_account_is_closed)
        end
      end

      context 'when receiver account is closed' do
        let(:receiver_account) { Account::Record.create(owner_name: 'John Doe', balance: 0, closed: true) }

        it 'returns a failure' do
          result = transfer

          expect(result).to be_a_failure
          expect(result.type).to eq(:receiver_account_is_closed)
        end
      end

      context 'when sender account has insufficient balance' do
        let(:amount) { 2001 }

        it 'returns a failure' do
          result = transfer

          expect(result).to be_a_failure
          expect(result.type).to eq(:insufficient_balance)
        end
      end
    end
  end
end