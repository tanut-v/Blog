class LikesController < ApplicationController
  def index
  	@post = Post.find(params[:post_id])
    @like = @post.likes.build(params[:like])
    @like.user = current_user
    @like.save
  	redirect_to posts_path
  end
  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(params[:like])
    @like.user = current_user
    @like.save
    redirect_to posts_path
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def show
    @like = Like.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @like }
    end
  end
end
