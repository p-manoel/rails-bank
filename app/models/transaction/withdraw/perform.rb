module Transaction
  class Withdraw::Perform < ::Micro::Case
    attribute :account, validates: { kind: Record }
    attribute :amount, validates: { kind: ::Float }

    def call!
      check_account
        .then(:create_transaction)
        .then(:update_account)
    end

    private

    def check_account
      return Failure(:account_is_closed) if account.closed
      return Failure(:insufficient_balance) if amount > account.balance

      Success(:account_checked)
    end

    def create_transaction
      Record.create!(account: account, _type: 'withdraw', amount: amount)

      Success(:transaction_created)
    end

    def update_account
      ::Account::Withdraw.call(account: account, amount: amount)

      Success(:withdraw_transaction_performed)
    end
  end
end