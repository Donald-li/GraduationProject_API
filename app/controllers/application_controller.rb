class ApplicationController < ActionController::API

  #判断是否登陆
  protected
  def logged_in?
    if session[:user_id].present?
      return true
    else
      return false
      # redirect_to account_login_path
    end
  end
  #要求登陆方法，过滤未登录情况
  def login_require

  end

end
