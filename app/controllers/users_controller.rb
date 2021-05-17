class UsersController < ManageBaseController
  before_action :logged_in?,only:[:show,:current_user]

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
  #登陆方法
  def login
    @user = User.new
    begin
      @user = User.find_by(account: params[:account])
      @articles = @user.articles.all
      if @user.password != params[:password]
        render json:{msg:'密码错误！'}
      else
        session[:user_id] = @user.id
        render json: { user:@user, user_articles:@articles}
      end
    rescue
      render json:{msg:'此账号不存在！'}
    end
  end
  #获得当前登陆用户
  def current_user
    render json: User.find(session[:user_id])
  end

  #获得当前用户所发表的文章
  def get_articles
    @user = User.find(params[:id])
    @articles = @user.articles.all
    render json: @articles
  end

  #获得当前用户的收藏文章列表
  def get_star_articles
    @user = User.find(params[:id])
    @star_articles = @user.star_articles.all
    render json: @star_articles.to_json(:include => :user)
  end

  #获取当前用户所关注用户列表
  def get_follow_user
    @user = User.find(params[:id])
    @fl= @user.followers.includes(:user).all
    # @fl.each do |f|
    #   @follow_users = @follow_users + {f.user.id => f.user}
    # end
    render json:@fl.to_json(:include => :user)
  end

end
