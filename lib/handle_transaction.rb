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
      add    = nil

      if params[:transaction_type] == "TF"
        Transaction.transaction do
          deduct = deduct_credit(params)
          add = add_credit(params)
        end
      elsif params[:transaction_type] == "AC"
        add = add_credit(params)
      elsif params[:transaction_type] == "DC"
        deduct = deduct_credit(params)
      end

      render_ws_response(deduct, add)
    end

    def add_credit(params)
      receiver = Transaction.new() do |r|
        r.user_id          = params[:to_user_id] ||= params[:user_id]
        r.account_id       = ActsAsTenant.current_tenant.id
        r.transaction_type = params[:transaction_type]
        r.info             = params[:info]
        r.fund             = params[:fund]
        # Following line added by Saravana
        r.currency         = params[:currency]
        r.operation        = "add"
      end
      receiver.save

      receiver
    end

    def deduct_credit(params)
      deducter = Transaction.new() do |r|
        r.user_id          = params[:user_id]
        r.account_id       = ActsAsTenant.current_tenant.id
        r.transaction_type = params[:transaction_type]
        r.info             = params[:info]
        r.fund             = "-#{params[:fund]}".to_f
        # Following line added by Saravana
        r.currency         = params[:currency]
        r.operation        = "deduct"
      end
      deducter.save

      deducter
    end

    private

    def render_ws_response(*args)
      responses = {}
      responses['errors'] = []
      responses['transaction_id'] = nil
      responses['success'] = false

      args.each do |o|
        next if o.nil? || o.errors.nil?

        responses['transaction_id'] = o.id unless o.id.nil?

        o.errors.each do |k,v|
          responses['errors'] << v
        end
      end
      responses['success'] = true unless responses['transaction_id'].nil? || responses['errors'].length > 0

      responses
    end
  end

end
