class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :subdomain, :limit => 100

      t.timestamps
    end
  end
end
