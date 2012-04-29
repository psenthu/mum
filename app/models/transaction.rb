class Transaction < ActiveRecord::Base
  extend HandleTransaction

  validates :user_id,   :numericality => { :message => "201" }
  validates :fund,      :numericality => { :message => "202" }

  acts_as_tenant(:account)

  def validation
    self.errors.add :fund, "200" if self.type == "TF" && 
                                    Transaction.fund_available

    self.errors.add :user_id, "201" unless User.find(self.user_id)
  end

end
