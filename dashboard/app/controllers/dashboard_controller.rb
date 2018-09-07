
class DashboardController < ApplicationController
  def index
    @bill_pay_transactions = YnabTransaction.order(date: :desc)
    @bank_transfers = BankTransaction.order(date: :desc).limit(10)
  end
end
