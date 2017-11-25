class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      return_with_ajax
    else
      user_error
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id])
    if @user
      @user = @user.followed
      current_user.unfollow @user
      return_with_ajax
    else
      user_error
    end
  end

  private

  def return_with_ajax
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def user_error
    flash[:danger] = I18n.t ".relationship.create.fail"
    redirect_to root_url
  end
end
