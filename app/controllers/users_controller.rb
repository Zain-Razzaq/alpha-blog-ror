class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create]
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to blogs_path, notice: 'User was successfully created.'
    else
      redirect_to register_path, alert: @user.errors.full_messages.to_sentence
    end
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end