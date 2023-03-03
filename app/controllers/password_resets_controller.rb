class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_password
      @user.send_password_reset_email
      flash[:info] = t ".sent_password_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].blank?
      @user.errors.add :password, t(".can_not_empty")
      render :edit
    if @user.update user_params
      log_in @user
      @user.update_column(:reset_digest, nil)
      flash[:success] = t ".password_has_been_reset"
      redirect_to @user
    else
      flash.now[:danger] = t ".password_reset_fail"
      render :edit
    end
  end

  private

  def find_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t ".user_invalid"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_reset_expired"
    redirect_to new_password_reset_url
  end
end
