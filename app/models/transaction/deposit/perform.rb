module Transaction::Deposit
  class Perform < ::Micro::Case
    attribute :account, validates: { kind: Account::Record }
    attribute :amount, validates: { kind: ::Float }

    def call!
      check_account
        .then(:create_transaction)
        .then(:update_account)
    end

    private

    def check_account
      return Failure(:account_is_closed) if account.closed

      Success(:account_checked)
    end

    def create_transaction
      transaction = ::Transaction::Record.create!(account: account, _type: 'deposit', amount: amount)

      Success(:transaction_created, result: { transaction: transaction })
    end

    def update_account
      ::Account::Deposit.call(account: account, amount: amount)

      Success(:deposit_transaction_performed)
    end
  end
end