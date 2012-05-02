class Transaction < ActiveRecord::Base
  include HandleTransaction

  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :account, :class_name => 'Account', :foreign_key => 'account_id'

  #validations
  validates :user_id,   :numericality => { :message => "201", 
                                           :greater_than => 0, 
                                           :only_integer => true, 
                                           :allow_nil => false }
  validates :fund,      :numericality => { :message => "202", 
                                           :allow_nil => false }
  validate  :validation

  #multi tenancy
  acts_as_tenant(:account)

  #attributes
  attr_accessor :to_user_id, :operation

  #callbacks
  before_save :set_user_id, :if => :transfer?

  private

  def set_user_id
    self.user_id = self.to_user_id
  end

  def transfer?
    !self.to_user_id.nil?
  end

  def validation
    self.errors.add :fund, "200" if self.type == "TF" && 
                                    self.fund && 
                                    self.operation == "deduct" && 
                                    !self.fund_available?
    return false
  end

end
