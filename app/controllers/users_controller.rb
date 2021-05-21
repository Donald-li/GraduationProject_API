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
  def get_session_user
    begin
      @user = User.find(params[:id])
      @articles = @user.articles.all
      render json: { user:@user, user_articles:@articles}
    rescue
      render json:{msg:'此账号不存在！'}
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
        # session[:user_id] = @user.id
        render json: { user:@user, user_articles:@articles}
      end
    rescue
      render json:{msg:'此账号不存在！'}
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

  #获取当前用户所关注用户列表(分页)
  def get_follow_user
    @user = User.find(params[:id])
    pagesize = params[:pagesize]
    offset = params[:offset]
    @fl= @user.followers.includes(:user).all.find_by_page(offset,pagesize)
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

  #关注用户
  def focues_user
    @user = User.find(params[:uid])
    @follower = User.find(params[:fid])

    @fl = FocuesRelation.new
    @fl.user = @user
    @fl.follower = @follower

    if @fl.save
      render json:{msg:'关注成功！'}
    else
      render json:{msg:'关注失败！'}
    end

  end
  #取消关注用户
  def unfocues
    @user = User.find(params[:uid])
    @follower = User.find(params[:fid])

    @fl = FocuesRelation.where("user_id = :user and follower_id = :follower",{user:@user.id,follower:@follower.id}).first
    if @fl.destroy
      render json:{msg:'取关成功！'}
    else
      render json:{msg:'取关失败！'}
    end
  end

  #判断是否为已关注用户，是返回1，不是返回2
  def isFocues
    @article = Article.find(params[:aid])
    uid = User.find(@article.user.id).id
    @user = User.find(uid)
    @follower = User.find(params[:fid])

    if @fl = FocuesRelation.where("user_id = :user and follower_id = :follower",{user:@user.id,follower:@follower.id}).first
      render json:{msg:1}
    else
      render json:{msg:2}
    end
  end

  #用户给文章评分
  def user_score_article
    @user = User.find(params[:uid])
    @article = Article.find(params[:aid])
    score = params[:score]

    @score_relation = ScoreRelation.new

    @score_relation.user = @user
    @score_relation.article = @article
    @score_relation.score = score

    if @score_relations = ScoreRelation.where("article_id = :aid and user_id = :uid",{aid:@article.id,uid:@user.id}).present?
      render json:{msg:'您已经评价过啦！',flag:0}
    else
      if @score_relation.save
        @score_relations = ScoreRelation.where("article_id = :aid",{aid:@article.id})
        totalscore = 0
        @score_relations.each do |sl|
          totalscore += sl.score
        end
        avascore = totalscore/@score_relations.count
        @article.score = avascore
        if @article.save
          render json:{msg:'评分成功！',flag:1}
        else
          render json:{msg:'评分保存失败！',flag:2}
        end
      else
        render json:{msg:'评分失败！',flag:3}
      end
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
