module Transaction
  class Transfer::Perform < ::Micro::Case
    attribute :amount, validates: { kind: ::Float, presence: true }
    attribute :sender_account, validates: { kind: Account::Record, presence: true }
    attribute :receiver_account, validates: { kind: ::Account::Record, presence: true }

    def call!
      check_accounts
        .then(:create_transaction)
        .then(:update_accounts)
    end

    private

    def check_accounts
      return Failure(:sender_account_is_closed) if sender_account.closed?
      return Failure(:receiver_account_is_closed) if receiver_account.closed?
      return Failure(:insufficient_balance) if (amount + calculate_fee) > sender_account.balance

      Success(:accounts_checked)
    end

    def create_transaction
      ::Transaction::Record.create!(
        _type: 'transfer',
        account: sender_account,
        amount: amount,
        receiver_account_id: receiver_account.id, 
        fee: calculate_fee
      )

      Success(:transaction_created)
    end

    def update_accounts
      ::Account::Withdraw.call(account: sender_account, amount: amount + calculate_fee)
      ::Account::Deposit.call(account: receiver_account, amount: amount)

      Success(:transfer_transaction_performed)
    end

    def calculate_fee
      fee = business_hours? ? 5 : 7

      fee += 10 if amount > 1000

      fee
    end

    def business_hours?
      current_time = Time.current

      if current_time.saturday? || current_time.sunday?
        return false
      end

      if current_time.hour < 9 || current_time.hour > 18
        return false
      end

      true
    end
  end
end