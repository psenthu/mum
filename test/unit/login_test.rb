require 'test_helper'

class LoginTest < ActiveSupport::TestCase

  def test_generate_token

    id = User.first.id
    @user = User.find(id)
    @user.reset_authentication_token!
    
    assert !@user.authentication_token.nil?
    
  end

  #def test_successful_token_access
  	#
  #end
  
  #def test_unsuccessful_token_access
  	#
  #end

end
