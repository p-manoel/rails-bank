module Account
  class Close < ::Micro::Case
    attribute :account, validates: { kind: Record }

    def call!
      account.update!(closed: true)

      Success(:account_closed)
    end
  end
end