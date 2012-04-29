class TransactionsController < ApplicationController
  include TransactionsHelper

  def transfer
    params[:info] = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:type] = "TF"

    respond_to do |format|
      format.xml { render :xml => render_ws_response(Transaction.transfer(params))}
    end
  end

  def add
    params[:type] = "AC"

    respond_to do |format|
      format.xml { render :xml => render_ws_response(Transaction.add_credit(params))}
    end
  end

  def deduct
    params[:type] = "DC"

    respond_to do |format|
      format.xml { render :xml => render_ws_response(Transaction.deduct_credit(params))}
    end
  end

end
