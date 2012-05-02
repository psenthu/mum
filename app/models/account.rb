class Account < ActiveRecord::Base
  has_many :transactions, :class_name => 'Transaction'
end
