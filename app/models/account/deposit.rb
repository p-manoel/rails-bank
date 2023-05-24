module Account
  class Deposit < ::Micro::Case
    attribute :account, validates: { kind: Record }
    attribute :amount, validates: { kind: ::Float }

    def call!
      return Failure(:account_is_closed) if account.closed

      account.update!(balance: account.balance + amount)

      Success(:amount_deposited)
    end
  end
end