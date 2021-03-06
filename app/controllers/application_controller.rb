class ApplicationController < ActionController::Base
  protect_from_forgery
  set_current_tenant_by_subdomain(:account, :subdomain)
  before_filter :authenticate_user!
end
