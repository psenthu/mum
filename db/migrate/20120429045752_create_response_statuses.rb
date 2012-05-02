class CreateResponseStatuses < ActiveRecord::Migration
  def change
    create_table :response_statuses do |t|
      t.integer :code
      t.string  :description,  :limit => 50

      t.timestamps
    end

    ResponseStatus.create!(:code => 100, :description => "Fund transfered successfully")
    ResponseStatus.create!(:code => 101, :description => "Fund credited successfully")
    ResponseStatus.create!(:code => 102, :description => "Fund deducted successfully")

    ResponseStatus.create!(:code => 200, :description => "Insufficient fund in transferer's account")
    ResponseStatus.create!(:code => 201, :description => "Invalid user")
    ResponseStatus.create!(:code => 202, :description => "Invalid fund")
    ResponseStatus.create!(:code => 203, :description => "Invalid currency")
  end
end
