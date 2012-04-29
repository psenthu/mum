class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :first_name, :limit => 100
      t.string  :last_name,  :limit => 100
      t.integer :account_id

      t.timestamps
    end
  end
end
