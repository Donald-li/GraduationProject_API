class ArticlesController < ManageBaseController
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
      render json: {'msg':'创建成功！'}
    else
      render json:{'msg':'创建失败！'}
    end
  end

  #接收上传的图片
  def upload_img
    #获得前端传来的文件
    file = params[:image]
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
end
