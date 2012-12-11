require 'test_helper'

class SclientsControllerTest < ActionController::TestCase

  test "create new sclient via rest call" do

    ActsAsTenant.current_tenant = accounts(:aightify)
    url = "http://aightify.localhost.com:3001/sclients?auth_token=123TEST"

    sclient = RestClient.post url,  :format   => :json,
                                    :sclient  => { :user_id => 156 }

    sclient = JSON.parse(sclient)
    assert_not_nil  sclient['id']
    assert_equal    sclient['user_id'], 156
  end

end
