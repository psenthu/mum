class TransactionsController < ApplicationController
  def transfer
    params[:info] = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:type] = "TF"

    respond_to do |format|
      format.xml { render :xml => Transaction.process_transaction(params)}
    end
  end

  def add
    params[:type] = "AC"

    respond_to do |format|
      format.xml { render :xml => Transaction.process_transaction(params)}
    end
  end

  def deduct
    params[:type] = "DC"

    respond_to do |format|
      format.xml { render :xml => Transaction.process_transaction(params)}
    end
  end

end
