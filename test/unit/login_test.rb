require 'test_helper'
require 'rest_client'

# *******************IMPORTANT*********************************
# Rails server must be running in test environment at port 3000
# for the following tests to pass.
# *************************************************************

class LoginTest < ActiveSupport::TestCase

  def test_generate_token

    id = User.first.id
    @user = User.find(id)
    @user.reset_authentication_token!
    
    assert !@user.authentication_token.nil?
    
  end
  
  def test_successful_token_access
  	load_fixtures_to_db
  	
  	url = "http://localhost:3000/transactions.json"
  	
  	begin
  		transactions = RestClient.get url+"?auth_token=123TEST"
  		transactions = JSON.parse(transactions)
  	rescue Exception => e
  		transactions = e
  	end
  	
  	assert_equal transactions.length, 2  	
  end

  def test_unsuccessful_wrong_token_access
  	load_fixtures_to_db
  	
  	url = "http://localhost:3000/transactions.json"
  	
  	begin
  		transactions = RestClient.get url+"?auth_token=GERTET356BVETHGDl"
  	rescue Exception => e
  		transactions = e
  	end
  	
  	assert_equal transactions.message, "401 Unauthorized"  	
  end
  
  def test_unsuccessful_no_token_access
  	load_fixtures_to_db
  	
  	url = "http://localhost:3000/transactions.json"
  	
  	begin
  		transactions = RestClient.get url
  	rescue Exception => e
  		transactions = e
  	end
  	
  	assert_equal transactions.message, "401 Unauthorized"
  end

end
