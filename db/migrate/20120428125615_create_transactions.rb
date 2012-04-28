class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :account_id
      t.integer :user_id
      t.string  :currency,  :length => 5
      t.string  :type,      :length => 5
      t.string  :info,      :length => 100
      t.decimal :fund,      :precision => 6, :scale => 2

      t.timestamps
    end
  end
end
