class UsersController < ManageBaseController
  # before_action :logged_in?,only:[:show]

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
    @user.account = get_user[:account]
    @user.name = get_user[:name]
    @user.password = get_user[:pass]
    @user.rule = get_user[:rule]
    @user.img = get_user[:imageUrl]
    if User.find_by(name: @user.name).present?
      render json:{msg:'账号昵称已存在！'}
    end
    if User.find_by(account:@user.account).present?
      render json:{msg:'账号已存在！'}
    else
      @user.save
      render json:{msg:'创建成功！'}
    end
  end
  def update
    @user = User.find(get_update_user[:id])
    @user.account = get_update_user[:account]
    @user.name = get_update_user[:name]
    @user.password = get_update_user[:password]
    @user.img = get_update_user[:img]
    if @user.save
      render json: {'msg'=>'修改成功！'}
    else
      render json: {'msg'=>'修改失败！'}
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
    if logged_in?
      @user = User.find(session[:user_id])
      @articles = @user.articles.all
      render json: { msg:1,user:User.find(session[:user_id]),user_articles:@articles }
    else
      render json: { msg:2 }
    end
  end

  #按页获得当前用户所发表的文章
  def get_articles
    @user = User.find(params[:id])
    offset = params[:offset].to_i
    pagesize = params[:pagesize].to_i
    total = @user.articles.ids.count
    offset = offset*pagesize
    @articles = @user.articles.find_by_page(offset,pagesize).sorted

    render json: { 'articles'=> @articles,'total'=>total }
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

  #获取上传的文件
  def uploadfile
    #获得前端传来的文件
    file = params[:file]
    if !file.original_filename.empty?
      @filename = file.original_filename
      #设置目录路径，如果目录不存在，生成新目录
      FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
      #写入文件
      ##wb 表示通过二进制方式写，可以保证文件不损坏
      File.open("#{Rails.root}/public/upload/#{@filename}", "wb") do |f|
        f.write(file.read)
      end
      render json: { 'FileURL'=>"/api/upload/#{@filename}" }
    end
  end

  private
  def get_user
    params.require(:ruleForm).permit(:pass,:account,:name,:rule,:img)
  end

  private
  def get_update_user
    params.require(:ruleForm).permit(:id,:password,:account,:name,:rule,:img)
  end

end
