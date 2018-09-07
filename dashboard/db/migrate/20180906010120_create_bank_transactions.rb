class CreateBankTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_transactions do |t|
      t.datetime :date
      t.string :to_acct
      t.string :from_acct
      t.integer :amount
      t.text :memo

      t.timestamps
    end
  end
end
