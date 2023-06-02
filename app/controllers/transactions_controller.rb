class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def index
    @transactions = ::Transaction::Record.where(account_id: @account.id).order(created_at: :desc)
  end

  def new
    @_type = params[:_type]
    @transaction = ::Transaction::Record.new(_type: @_type, account_id: @account.id)
  end

  def create
    if transaction_params[:_type] == 'deposit'
      ::Transaction::Deposit::Perform.call(account: @account, amount: transaction_params[:amount].to_f)
        .on_success { redirect_to transactions_path, notice: 'Deposit was successfully done.' }
        .on_failure { |result| redirect_to transactions_path, alert: "#{ result.type.to_s.humanize }" }
        .on_unknown { redirect_to transactions_path, alert: 'Something went wrong.' }
    elsif transaction_params[:_type] == 'withdraw'
      ::Transaction::Withdraw::Perform.call(account: @account, amount: transaction_params[:amount].to_f)
        .on_success { redirect_to transactions_path, notice: 'Withdraw was successfully done.' }
        .on_failure { |result| redirect_to transactions_path, alert: "#{ result.type.to_s.humanize }" }
        .on_unknown { redirect_to transactions_path, alert: 'Something went wrong.' }
    elsif transaction_params[:_type] == 'transfer'
      receiver_account = ::Account::Record.find_by(id: transaction_params[:receiver_account_id])

      ::Transaction::Transfer::Perform.call(sender_account: @account, amount: transaction_params[:amount].to_f, receiver_account: receiver_account)
        .on_success { redirect_to transactions_path, notice: 'Transfer was successfully done.' }
        .on_failure { |result| redirect_to transactions_path, alert: "#{ result.type.to_s.humanize }" }
        .on_unknown { redirect_to transactions_path, alert: 'Something went wrong.' }
    else
      redirect_to transactions_path, alert: 'Something went wrong.'
    end
  end

  private

  def set_account
    @account = current_user.account
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :_type, :receiver_account_id)
  end
end
