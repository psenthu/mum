class Transaction < ActiveRecord::Base
  validates :user_id,   :presence => true
  validates :currency,  :presence => true
  validates :fund,      :presence => true, :numericality => true

  acts_as_tenant(:account)

  class << self
    def transfer(params)
      Transaction.transaction do
        add_credit(params)
        deduct_credit(params)
      end
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

      receiver.save
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

      transferer.save
    end
  end

end
