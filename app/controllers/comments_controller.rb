class CommentsController < ApplicationController
  def create
    @user = User.find(params[:uid])
    @article = Article.find(params[:aid])
    text = params[:text]
    @comment = Comment.new

    @comment.body = text
    @comment.user = @user
    @comment.article = @article

    if @comment.save
      render json:{msg:'评论成功！',flag:1}
    else
      render json:{msg:'评论失败！',flag:2}
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment.destroy
      render json:{msg:'删除成功！'}
    else
      render json:{msg:'删除失败！'}
    end
  end
end
