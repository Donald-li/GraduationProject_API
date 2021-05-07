class UsersController < ApplicationController
  def index
    @users = User.all
    render json:@users
  end
  def show
    @user = User.find(params[:id])
    render json:@user
  end
  def create
    @user = User.new

  end

  private
  def users_params
    params.require(:user).permit(:account,:name,:password,:rule,:img)
  end
end
