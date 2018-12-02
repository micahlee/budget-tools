# frozen_string_literal: true

require 'ally/interface'

class BankTransactionsController < ApplicationController
  def index
    @transactions = BankTransaction.all.order(date: :desc)
  end

  def sync
    already_exist_tries = 3

    event_handler = lambda do |msg|
      p "DBG: ally event: #{msg}"

      ProgressChannel.broadcast_to(
        "progress_ally",
        message: msg
      )
    end

    interface = Ally::Interface.new
    interface.transactions(event_handler).each do |transaction|
      p "DBG: transaction=#{transaction}"
      already_exists = BankTransaction.where(
        date: transaction.date,
        to_acct: transaction.to_acct,
        from_acct: transaction.from_acct,
        amount: transaction.amount,
        memo: transaction.memo
      ).exists?

      if already_exists
        already_exist_tries -= 1
      else
        transaction.save!
      end

      break if already_exist_tries == 0
    end

    event_handler.call "Done!";
  end
end
