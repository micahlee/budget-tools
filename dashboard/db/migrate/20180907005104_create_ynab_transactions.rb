class CreateYnabTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :ynab_transactions do |t|
      t.datetime :date
      t.string :category
      t.string :payee
      t.integer :amount

      t.timestamps
    end
  end
end
