# frozen_string_literal: true

require 'ynab/interface'

class YnabController < ApplicationController
  def sync
    YnabTransaction.delete_all
    ynab.get_bill_pay_transactions.each(&:save!)
  end

  protected

  def ynab
    YNAB::Interface.new
  end
end
