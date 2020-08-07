class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:sessions][:email].downcase
    if user&.authenticate params[:sessions][:password]
      if user.activated?
        remember_user user
      else
        flash[:warning] = t ".alert_mess_create"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".fail_mess_create"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def remember_user user
    log_in user
    params[:sessions][:remember_me] == Settings.sessions.create.select_box ? remember(user) : forget(user)
    flash[:success] = t ".success_mess"
    redirect_back_or user_path user
  end
end
