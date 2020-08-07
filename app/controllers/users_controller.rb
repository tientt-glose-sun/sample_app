class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, except: %i(index new create)

  def index
    @users = User.is_activated.page params[:page]
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".info_mess_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t ".fail_mess_create"
      render :new
    end
  end

  def new
    @user = User.new
  end

  def show
    redirect_to(root_url) && return unless @user.activated?
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success_mess_update"
      redirect_to user_path @user
    else
      flash.now[:danger] = t ".fail_mess_update"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".success_mess_delete"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".login_remind"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".fail_mess_notfound"
    redirect_to root_url
  end
end
