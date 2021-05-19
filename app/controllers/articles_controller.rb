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

  private
  def attach_article
    params.require(:article).permit(:title,:body,:section,:user_id)
  end
end
