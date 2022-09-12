class PostsController < ApplicationController
  def show
    post = Post.find(params[:id])
    render json: { post: post, comments: post.comments }, status: 200
  rescue ActiveRecord::RecordNotFound
    render html: 'User not exists', status: 400
  end
end
