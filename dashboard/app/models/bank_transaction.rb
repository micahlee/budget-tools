class BankTransaction < ApplicationRecord
  def amount_dollars
    amount / 1000.0
  end
end
