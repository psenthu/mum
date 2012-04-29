class Transaction < ActiveRecord::Base
  validates :user_id,   :numericality => { :message => ResponseStatus.find_by_code("201").code }
  validates :fund,      :numericality => { :message => ResponseStatus.find_by_code("202").code }
  validates :currency,  :numericality => { :message => ResponseStatus.find_by_code("203").code }

  acts_as_tenant(:account)

  def validation
    self.errors.add :fund, ResponseStatus.find_by_code("200") if self.type == "TF" && 
                                                                 Transaction.fund_for_user(self.user_id)

    #self.errors.add :user_id, ResponseStatus.find_by_code("201") unless User.find(self.user_id)
  end

  class << self
    def fund_for_user
      Transaction.where("user_id = ?", self.user_id).
                  sum("fund")
    end

    def transfer(params)
      response = []

      Transaction.transaction do
        response << deduct_credit(params)
        response << add_credit(params)
      end

      response
    end

    def add_credit(params)
      receiver = Transaction.new do |p|
        p.account_id = ActsAsTenant.current_tenant.id,
        p.user_id    = params[:to_user_id],
        p.currency   = params[:currency],
        p.info       = params[:info],
        p.fund       = params[:fund],
        p.type       = params[:type]
      end

      receiver.save ? [] : receiver.errors
    end

    def deduct_credit(params)
      transferer = Transaction.new do |p|
        p.account_id = ActsAsTenant.current_tenant.id,
        p.user_id    = params[:user_id],
        p.currency   = params[:currency],
        p.info       = params[:info],
        p.fund       = "-#{params[:fund]}".to_f
        p.type       = params[:type]
      end

      transferer.save ? [] : transferer.errors
    end
  end

end
