require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  def test_successful_fund_transfer
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params                      = {}
    params[:user_id]            = sclients(:one).user_id
    params[:to_user_id]         = sclients(:two).user_id
    params[:fund]               = 100
    params[:currency]           = "POUND"
    params[:info]               = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:transaction_type]   = "TF"

    response = Transaction.process_transaction(params)

    assert_equal response['errors'].length, 0
    assert_equal response['success'], true
    assert_not_nil response['transaction_id']
  end

  ## Written by Saravana: Test to check transaction failure due to insufficient fund

  def test_insufficient_fund_transfer_error
  	load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params                      = {}
    params[:user_id]            = sclients(:one).user_id
    params[:to_user_id]         = sclients(:two).user_id
    params[:fund]               = 200
    params[:currency]           = "POUND"
    params[:info]               = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:transaction_type]   = "TF"

    response = Transaction.process_transaction(params)

    assert_equal response['errors'].length, 1
    assert_equal response['success'], false
  end

  ####### Test End #################################################################

  def test_un_successful_fund_transfer
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params                      = {}
    params[:user_id]            = "nn"
    params[:to_user_id]         = 88
    params[:fund]               = 100
    params[:currency]           = "POUND"
    params[:info]               = "receiver: #{params[:to_user_id]}\ntransferer: #{params[:user_id]}"
    params[:transaction_type]   = "TF"

    response = Transaction.process_transaction(params)

    assert_equal response['errors'].length, 4
    assert_equal response['success'], false
    assert_equal response['transaction_id'], nil
  end

  def test_successful_add_credit
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params                      = {}
    params[:user_id]            = sclients(:one).user_id
    params[:fund]               = 100
    params[:currency]           = "POUND"
    params[:info]               = "receiver: #{params[:user_id]}"
    params[:transaction_type]   = "AC"

    response = Transaction.process_transaction(params)

    assert_equal response['errors'].length, 0
    assert_equal response['success'], true
    assert_not_nil response['transaction_id']
  end

  def test_un_successful_add_credit
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params                      = {}
    params[:user_id]            = 90
    params[:cash]               = 100
    params[:currency]           = "POUND"
    params[:info]               = "receiver: #{params[:user_id]}"
    params[:transaction_type]   = "AC"

    response = Transaction.process_transaction(params)

    assert_equal response['errors'].length, 2
    assert_equal response['success'], false
    assert_equal response['transaction_id'], nil
  end

  def test_successful_deduct_credit
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params                      = {}
    params[:user_id]            = sclients(:one).user_id
    params[:fund]               = 100
    params[:currency]           = "POUND"
    params[:info]               = "receiver: #{params[:user_id]}"
    params[:transaction_type]   = "DC"

    response = Transaction.process_transaction(params)

    assert_equal response['errors'].length, 0
    assert_equal response['success'], true
    assert_not_nil response['transaction_id']
  end

  def test_un_successful_deduct_credit
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    params                      = {}
    params[:user_id]            = 9
    params[:cash]               = 100
    params[:currency]           = "POUND"
    params[:info]               = "receiver: #{params[:user_id]}"
    params[:transaction_type]   = "DC"

    response = Transaction.process_transaction(params)

    assert_equal response['errors'].length, 1
    assert_equal response['success'], false
    assert_equal response['transaction_id'], nil
  end

end
