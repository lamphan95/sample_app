class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      create_success @user
    else
      flash.now[:danger] = I18n.t "password_resets.create.fail"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      update_empty @user
    elsif @user.update_attributes user_params
      update_success @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    redirect_to root_url unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = I18n.t "password_resets.update.over_expired"
    redirect_to new_password_reset_url
  end

  def update_success user
    log_in user
    user.update_attribute :reset_digest, nil
    flash[:success] = I18n.t "password_resets.update.success"
    redirect_to user
  end

  def update_empty user
    user.errors.add :password, I18n.t("password_resets.update.fail")
    render :edit
  end

  def create_success user
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = I18n.t "password_resets.create.success"
    redirect_to root_url
  end
end
