class Sclient < ActiveRecord::Base
  attr_accessible :user_id
  validates_uniqueness_of :user_id

  has_many :transactions, :class_name => 'Transaction', :primary_key => "user_id", :foreign_key => "user_id"
end
