class PostsController < ApplicationController
  def show
    post = Post.find(params[:id])
    render json: { post: post, comments: post.comments }
  end
end
