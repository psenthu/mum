require 'test_helper'
require 'rest_client'

class TransactionsControllerTest < ActionController::TestCase

  # *************************************************************************
  #  Test written by Saravana on 03-12-2012: get account details for user id
  # *************************************************************************

  def test_get_all_account_history_for_user
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    url     = "http://aightify.localhost.com:3000/transactions"

    transactions = RestClient.get url+"/1/account?auth_token=123TEST"
    transactions = JSON.parse(transactions)

    assert_equal Transaction.count, 2
    assert_equal transactions.length, 1
    assert_equal transactions[0]['user_id'], 1
  end

  def test_successfully_add_credit_via_rest
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    url = "http://aightify.localhost.com:3000/transactions"+"/1/add/150.0/LKR?auth_token=123TEST"

    add_credit = RestClient.post url, {}
    add_credit = JSON.parse(add_credit)    

    assert_equal add_credit['errors'].length, 0
    assert_not_nil add_credit['transaction_id']
  end

  def test_fail_to_add_credit_via_rest
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    url = "http://aightify.localhost.com:3000/transactions"+"/5/add/150.0/LKR?auth_token=123TEST"

    add_credit = RestClient.post url, {}
    add_credit = JSON.parse(add_credit)

    assert_equal add_credit['errors'].length, 1
  end

  def test_successfully_deduct_credit_via_rest
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    url = "http://aightify.localhost.com:3000/transactions"+"/2/deduct/150.0/LKR?auth_token=123TEST"

    add_credit = RestClient.post url, {}
    add_credit = JSON.parse(add_credit)

    assert_equal add_credit['errors'].length, 0
    assert_not_nil add_credit['transaction_id']
  end

  def test_fail_to_deduct_credit_via_rest
    load_fixtures_to_db

    ActsAsTenant.current_tenant = accounts(:aightify)

    url = "http://aightify.localhost.com:3000/transactions"+"/5/deduct/150.0/LKR?auth_token=123TEST"

    add_credit = RestClient.post url, {}
    add_credit = JSON.parse(add_credit)

    assert_equal add_credit['errors'].length, 1
  end

end
