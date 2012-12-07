class SclientsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @sclient = Sclient.new(params[:sclient])

    if @sclient.save
      respond_to do |format|
        format.json { render :json => @sclient }
      end
    end

  end

end
