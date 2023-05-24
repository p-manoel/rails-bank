module Account
  class Withdraw < ::Micro::Case
    attribute :account, validates: { kind: Record }
    attribute :amount, validates: { kind: ::Float }

    def call!
      return Failure(:account_is_closed) if account.closed

      return Failure(:insufficient_balance) if amount > account.balance

      account.update!(balance: account.balance - amount)

      Success(:amount_withdrawn)
    end
  end
end