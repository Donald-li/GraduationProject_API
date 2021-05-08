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
    @user.account = params[:account]
    @user.name = params[:name]
    @user.password = params[:password]
    @user.rule = params[:rule]
    @user.img = params[:img]
    if User.find_by(name: @user.name).present?
      @user.errors
    else
      @user.save
    end
  end

  def login
    @user = User.new
    begin
      @user = User.find_by(account: params[:account])
      if @user.password != params[:password]
        render json:{msg:'密码错误！'}
      else
        render json:@user
      end
    rescue
      render json:{msg:'此账号不存在！'}
    end
  end
end
