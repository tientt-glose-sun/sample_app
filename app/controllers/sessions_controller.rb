class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:sessions][:email].downcase
    if user&.authenticate params[:sessions][:password]
      log_in user
      flash[:success] = t ".success_mess"
      redirect_to user_path user
    else
      flash.now[:danger] = t ".fail_mess_create"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
