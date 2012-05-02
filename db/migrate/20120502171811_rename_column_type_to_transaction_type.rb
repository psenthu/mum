class RenameColumnTypeToTransactionType < ActiveRecord::Migration
  def up
    rename_column :type, :transaction_type
  end

  def down
    rename_column :transaction_type, :type
  end
end
