class TransactionsController < ApplicationController

  def transfer
    params[:info] = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:type] = "TF"

    Transaction.transfer(params)

    respond_to do |format|
      format.xml { render :xml => "OK"}
    end
  end

  def add
    params[:type] = "AC"

    Transaction.add_credit(params)

    respond_to do |format|
      format.xml { render :xml => "OK"}
    end
  end

  def deduct
    params[:type] = "DC"

    Transaction.deduct_credit(params)

    respond_to do |format|
      format.xml { render :xml => "OK"}
    end
  end

end
