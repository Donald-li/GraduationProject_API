class MainController < ManageBaseController

  def init
    @article = Article.show.where(section:params[:title]).limit(5).sorted_score
    render json: @article.to_json(:include => :user)
  end

  def initSections
    @article = Article.show.where(section:params[:title]).sorted_score
    render json: @article.to_json(:include => :user)
  end

end