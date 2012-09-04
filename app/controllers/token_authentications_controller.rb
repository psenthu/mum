class TokenAuthenticationsController < ApplicationController
	respond_to :json, :html

  def create
  	puts "We got #{params.inspect}"
    @user = User.find(params[:id])
    @user.reset_authentication_token!

    render :status=>200, :json=>{:token=>@user.authentication_token}
  end

  def destroy
    @user = User.find(params[:id])
    @user.authentication_token = nil
    @user.save

    render :status=>200, :json=>{:token=>@user.authentication_token}
  end

end
