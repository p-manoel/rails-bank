class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def index
    @transactions = ::Transaction::Record.where(account_id: @account.id)
  end

  def new
    @_type = params[:_type]
    @transaction = ::Transaction::Record.new(_type: @_type, account_id: @account.id)
  end

  def create
    puts transaction_params
    if transaction_params[:_type] == 'deposit'
      ::Transaction::Deposit::Perform.call(account: @account, amount: transaction_params[:amount].to_f)
      .on_success { redirect_to transactions_path, notice: 'Deposit was successfully done.' }
      .on_failure(:account_is_closed) { redirect_to transactions_path, alert: 'Your account is closed.' }
      .on_unknown { redirect_to transactions_path, alert: 'Something went wrong.' }
    elsif transaction_params[:_type] == 'withdraw'
      ::Transaction::Withdraw::Perform.call(account: @account, amount: transaction_params[:amount].to_f)
      .on_success { redirect_to transactions_path, notice: 'Withdraw was successfully done.' }
      .on_failure(:account_is_closed) { redirect_to transactions_path, alert: 'Your account is closed.' }
      .on_failure(:insufficient_balance) { redirect_to transactions_path, alert: 'Insufficient balance.' }
      .on_unknown { redirect_to transactions_path, alert: 'Something went wrong.' }
    elsif transaction_params[:_type] == 'transfer'
      ::Transaction::Transfer::Perform.call(account: @account, amount: transaction_params[:amount].to_f, receiver_account_id: transaction_params[:receiver_account_id])
      .on_success { redirect_to transactions_path, notice: 'Transfer was successfully done.' }
      .on_failure(:account_is_closed) { redirect_to transactions_path, alert: 'Your account is closed.' }
      .on_failure(:insufficient_balance) { redirect_to transactions_path, alert: 'Insufficient balance.' }
      .on_failure(:to_account_is_closed) { redirect_to transactions_path, alert: 'Receiver account is closed.' }
      .on_unknown { redirect_to transactions_path, alert: 'Something went wrong.' }
    else
      redirect_to :root, alert: 'Something went wrong.'
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
