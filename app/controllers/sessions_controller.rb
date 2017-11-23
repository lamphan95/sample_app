class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        login_success_activated @user
      else
        login_success_not_activated
      end
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
