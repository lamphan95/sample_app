class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, only: %i(show destroy)
  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = I18n.t ".static_pages.home.str4"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = I18n.t ".users.update.success"
      redirect_to @user
    else
      render :edit
    end
  end

  def index
    @users = User.paginate page: params[:page]
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t ".users.destroy.success"
    else
      flash[:danger] = I18n.t ".users.destroy.fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = I18n.t ".users.helper.not_login"
    redirect_to login_path
  end

  def correct_user
    @user = User.find_by params[:id]
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = I18n.t ".users.show.error_message"
    redirect_to root_path
  end
end
