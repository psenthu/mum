require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  def test_successful_fund_transfer
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params = {}
    params[:user_id]    = users(:pragash).id
    params[:to_user_id] = users(:mathu).id
    params[:fund]       = 100
    params[:currency]   = "POUND"
    params[:info]       = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:transaction_type] = "TF"

    assert_equal Transaction.process_transaction(params).length, 0
  end
  
  ## Written by Saravana: Test to check transaction failure due to insufficient fund
  
  def test_insufficient_fund_transfer_error
  	load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params = {}
    params[:user_id]    = users(:pragash).id
    params[:to_user_id] = users(:mathu).id
    params[:fund]       = 200
    params[:currency]   = "POUND"
    params[:info]       = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:transaction_type] = "TF"

    assert_equal Transaction.process_transaction(params).length, 1
  end
  
  ## Test End ######################################################################

  def test_un_successful_fund_transfer
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params = {}
    params[:user_id]    = "nn"
    params[:to_user_id] = 88
    params[:fund]       = 100
    params[:currency]   = "POUND"
    params[:info]       = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:transaction_type] = "TF"

    assert_equal Transaction.process_transaction(params).length, 4
  end

  def test_successful_add_credit
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params = {}
    params[:user_id]    = 1
    params[:fund]       = 100
    params[:currency]   = "POUND"
    params[:info]       = "receiver: #{params[:user_id]}"
    params[:transaction_type] = "AC"

    assert_equal Transaction.process_transaction(params).length, 0
  end

  def test_un_successful_add_credit
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params = {}
    params[:user_id]    = 90
    params[:cash]       = 100
    params[:currency]   = "POUND"
    params[:info]       = "receiver: #{params[:user_id]}"
    params[:transaction_type] = "AC"

    assert_equal Transaction.process_transaction(params).length, 2
  end

  def test_successful_deduct_credit
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params = {}
    params[:user_id]    = 1
    params[:fund]       = 100
    params[:currency]   = "POUND"
    params[:info]       = "receiver: #{params[:user_id]}"
    params[:transaction_type] = "DC"

    assert_equal Transaction.process_transaction(params).length, 0
  end

  def test_un_successful_deduct_credit
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params = {}
    params[:user_id]    = 9
    params[:cash]       = 100
    params[:currency]   = "POUND"
    params[:info]       = "receiver: #{params[:user_id]}"
    params[:transaction_type] = "DC"

    assert_equal Transaction.process_transaction(params).length, 1
  end

end
