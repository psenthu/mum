class Sclient < ActiveRecord::Base
  has_many :transactions, :class_name => 'Transaction', :primary_key => "user_id", :foreign_key => "user_id"

  attr_accessible :user_id
  validates :user_id, :uniqueness => true

  # => multi tenancy
  acts_as_tenant(:account)
end
