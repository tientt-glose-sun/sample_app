class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".info_mess_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t ".fail_mess_create"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, :blank
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t ".success_mess_update"
      redirect_to user_path(@user)
    else
      flash[:danger] = t ".fail_mess_create"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS_RESET
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash.now[:danger] = t ".fail_mess_create"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".fail_mess_expired"
    redirect_to new_password_reset_url
  end
end
