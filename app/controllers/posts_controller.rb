class PostsController < ApplicationController
  before_action :authorize, only: [:create, :index]

  def show
    post = Post.find(params[:id])
    render json: { post: post, comments: post.comments }
  end

  def index
    posts = @user.posts
    render status: 200, json: {users_posts: posts}
  end

  def create
    new_post = Post.new(posts_params)
    new_post[:user_id] = @user[:id]
    if new_post.save
      render status: 200, html: 'post saved'
    else
      render status: 400, html: 'post not saved'
    end
  end

  private

  def posts_params
    params.require(:post_data).permit(:content, :image)
  end

end
