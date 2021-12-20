class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      do_remember user
      redirect_to user
    else
      flash.now[:danger] = t ".invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def do_remember user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end
end
