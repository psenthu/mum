class TransactionsController < ApplicationController
	before_filter :authenticate_user!

	def index
		@transactions = []

    if params[:user_id]
      @transactions = Transaction.where(:user_id => params[:user_id])
    else
      @transactions = Transaction.all
    end

		respond_to do |format|
      format.json { render :json => @transactions}
    end
	end

  def summary
    @transaction = {}

    if params[:user_id]
      @transaction['money']    = Transaction.where(:user_id => params[:user_id]).sum('fund')
      @transaction['currency'] = "USD"
    end

    respond_to do |format|
      format.json { render :json => @transaction }
    end
  end

  def transfer
    params[:info] = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:transaction_type] = "TF"
    binding.pry
    respond_to do |format|
      format.html { render :json => Transaction.process_transaction(params)}
    end
  end

  def add
    params[:transaction_type] = "AC"

    respond_to do |format|
      format.html { render :json => Transaction.process_transaction(params)}
    end
  end

  def deduct
    params[:transaction_type] = "DC"

    respond_to do |format|
      format.html { render :json => Transaction.process_transaction(params)}
    end
  end

end
