class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params[:comment])
    @comment.user = current_user
    @comment.save
    UserMailer.notification_email(@post.user,current_user).deliver
    redirect_to posts_path
  end
end
