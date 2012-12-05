class CreateSclients < ActiveRecord::Migration
  def change
    create_table :sclients do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
