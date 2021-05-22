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

  #获取当前用户所关注用户列表(分页)
  def get_follow_user
    @user = User.find(params[:id])
    pagesize = params[:pagesize]
    offset = params[:offset]
    @fl= @user.followers.includes(:user).all.find_by_page(offset,pagesize)
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

  #用户给文章点赞
  def user_thumb_article
    @user = User.find(params[:uid])
    @article = Article.find(params[:aid])

    @tl = ThumbRelation.new
    @tl.user = @user
    @tl.article = @article

    if ThumbRelation.where("user_id = :uid and article_id = :aid",{uid:@user.id,aid:@article.id}).present?
      render json:{msg:'您已经点过赞啦！',flag:0}
    else
      if @tl.save
        # totalThumb = ThumbRelation.where("article_id = :aid",{aid:@article.id}).count
        @article.thumbs = @article.thumbs+1
        if @article.save
          render json:{msg:'点赞成功！',flag:1}
        else
          render json:{msg:'点赞保存失败！',flag:2}
        end
      else
        render json:{msg:'点赞失败！',flag:3}
      end
    end
  end

  #用户收藏文章
  def user_collect_article
    @user = User.find(params[:uid])
    @article = Article.find(params[:aid])

    @cl = CollectRelation.new
    @cl.user = @user
    @cl.article = @article

    if CollectRelation.where("user_id = :uid and article_id = :aid",{uid:@user.id,aid:@article.id}).present?
      render json:{msg:'您已经收藏啦！',flag:0}
    else
      if @cl.save
        render json:{msg:'收藏成功！',flag:1}
      else
        render json:{msg:'收藏失败！',flag:2}
      end
    end
  end

  #用户取消收藏文章
  def uncollect
    @user = User.find(params[:uid])
    @article = Article.find(params[:aid])

    @cl = CollectRelation.where("user_id = :uid and article_id = :aid",{uid:@user.id,aid:@article.id}).first

    if @cl.destroy
      render json:{msg:'取消收藏成功！'}
    else
      render json:{msg:'取消收藏失败！'}
    end
  end

  #用户取消点赞
  def unthumb
    @article = Article.find(params[:aid])

    @tl = ThumbRelation.where("user_id = :uid and article_id = :aid",{uid:params[:uid],aid:params[:aid]}).first
    if @tl.destroy
      @article.thumbs = @article.thumbs-1
      if @article.save
        render json:{msg:'取消点赞成功！'}
      else
        render json:{msg:'取消点赞保存失败！'}
      end
    else
      render json:{msg:'取消点赞失败！'}
    end

  end

  #获得用户收藏的所有文章（分页）
  def get_collect_page
    @user = User.find(params[:uid])
    pagesize = params[:pagesize]
    offset = params[:offset]

    @cl = @user.collect_relations.includes(:article).all.find_by_page(offset,pagesize).sorted

    render json:@cl.to_json(:include => { :article => {:include => :user} })
  end

  #获得用户收藏文章的总数
  def get_collect_count
    @user = User.find(params[:uid])
    total = @user.collect_relations.count

    render json:{total:total}
  end

  #获得用户关注用户的总数
  def get_focues_count
    @user = User.find(params[:uid])
    total = @user.followers.all.count

    render json:{total:total}
  end

  #判断是否点赞过文章：1-已点赞，2-未点赞
  def isThumb
    @user = User.find(params[:uid])
    @article = Article.find(params[:aid])

    if ThumbRelation.where("user_id = :uid and article_id = :aid",{uid:@user.id,aid:@article.id}).present?
      render json:{msg:'您已经点过赞啦！',flag:1}
    else
      render json:{msg:'还未点过赞！',flag:2}
    end
  end

  #判断是否收藏过此文章：1-已收藏，2-未收藏
  def isCollect
    @user = User.find(params[:uid])
    @article = Article.find(params[:aid])

    if CollectRelation.where("user_id = :uid and article_id = :aid",{uid:@user.id,aid:@article.id}).present?
      render json:{msg:'您已经收藏过啦！',flag:1}
    else
      render json:{msg:'还未收藏！',flag:2}
    end
  end

  #用户获得所关注用户的动态方法
  def active_user
    @user = User.find(params[:uid])
    @fl = @user.followers.all
    focus = []
    @fl.each do |fl|
      focus<<fl.user.id
    end
    @articles = Article.where("user_id in (:users)",{users:focus}).limit(100).offset(0).sorted

    render json:@articles.to_json(:include => :user)

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
