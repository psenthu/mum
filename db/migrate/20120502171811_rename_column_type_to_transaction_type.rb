class RenameColumnTypeToTransactionType < ActiveRecord::Migration
  def up
    rename_column :transactions, :type, :transaction_type
  end

  def down
    rename_column :transactions, :transaction_type, :type
  end
end
