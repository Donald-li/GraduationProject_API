class MainController < ManageBaseController

  def init
    @article = Article.where(section:params[:title]).limit(5).sorted_score
    render json: @article.to_json(:include => :user)
  end

end