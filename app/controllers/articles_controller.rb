class ArticlesController < ManageBaseController
  # before_action :logged_in?,only:[:destroy]

  def show
    @article = Article.find(params[:id])
    render json:@article.to_json(:include => :user)
  end
  def create
    @article = Article.new
    @article.title = attach_article[:title]
    @article.body = attach_article[:body]
    @article.user = User.find(attach_article[:user_id])
    @article.section = attach_article[:section]
    @article.score = 0
    @article.thumbs = 0
    if @article.save
      render json: {'msg':'发布成功！'}
    else
      render json:{'msg':'发布失败！'}
    end
  end
  def update
    @article = Article.find(attach_edit_article[:id])
    @article.title = attach_edit_article[:title]
    @article.body = attach_edit_article[:body]
    @article.section = attach_edit_article[:section]

    if @article.save
      render json:{msg:'修改成功！'}
    else
      render json:{msg:'修改失败！'}
    end
  end
  def destroy
    @article = Article.find(params[:id])
    if @article.destroy
      render json:{'msg':'删除成功！'}
    else
      render json:{'msg':'删除失败！'}
    end

  end

  def show_article
    @article = Article.find(params[:id])
    render json:{"article":@article}
  end

  def show_by_page_index
    offset = params[:offset]
    pagesize = param[:pagesize]

    @articles = Article.show.find_by_page(offset,pagesize).reverse_sorted
  end

  #搜索功能
  def search
    @articles = Article.show.where("title like :array",{array:'%'+params[:array]+'%'})
    render json:@articles.to_json(:include=>:user)
  end

  #获得某文章的评论功能
  def get_comment
    @user = User.find(params[:uid])
    @article = Article.find(params[:aid])

    @comments = @article.comments.show

    render json:@comments.to_json(:include => :user)
  end

  #接收上传的图片
  def upload_img
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
      render json: { "errno": 0, "data" => ["url" =>"/api/upload/#{@filename}"] }
    end
  end

  private
  def attach_article
    params.require(:article).permit(:title,:body,:section,:user_id)
  end
  private
  def attach_edit_article
    params.require(:article).permit(:id,:title,:body,:section,:score,:thumbs,:user_id)
  end
end
