module HandleTransaction

  def self.included(base)
    base.extend ClassMethods
  end

  def fund_available?
    Transaction.user_fund(self.user_id).sum("fund") > self.fund.abs
  end

  module ClassMethods
    def process_transaction(params)
      deduct = nil
      add = nil

      if params[:type] == "TF"
        Transaction.transaction do
          deduct = deduct_credit(params)
          add = add_credit(params)
        end
      elsif params[:type] == "AC"
        add = add_credit(params)
      elsif params[:type] == "DC"
        deduct = deduct_credit(params)
      end

      render_ws_response(deduct, add)
    end

    def add_credit(params)
      receiver = Transaction.new() do |r|
        r.user_id = params[:to_user_id] ||= params[:user_id]
        r.account_id = ActsAsTenant.current_tenant.id
        r.type = params[:type]
        r.info = params[:info]
        r.fund = params[:fund]
        r.operation = "add"
      end
      receiver.save

      receiver
    end

    def deduct_credit(params)
      deducter = Transaction.new() do |r|
        r.user_id = params[:user_id]
        r.account_id = ActsAsTenant.current_tenant.id
        r.type = params[:type]
        r.info = params[:info]
        r.fund = "-#{params[:fund]}".to_f
        r.operation = "deduct"
      end
      deducter.save

      deducter
    end

    private

    def render_ws_response(*args)
      responses = []

      args.each do |o|
        next if o.nil? || o.errors.nil?

        o.errors.each do |k,v|
          responses << v
        end
      end

      responses
    end
  end

end