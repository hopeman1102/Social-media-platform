class PostsController < ApplicationController
  before_action :authorize, only: [:create, :index]

  def show
    post = Post.find(params[:id])
    render json: { post: post, comments: post.comments }, status: 200
  rescue ActiveRecord::RecordNotFound
    render html: 'User not exists', status: 400
  end

  def index
    posts = @user.posts
    render status: 200, json: {users_posts: posts}
  end

  def create
    new_post = Post.new(posts_params)
    new_post.content.strip!
    new_post[:user_id] = @user[:id]
    if new_post.save
      render status: 200, html: 'post saved'
    else
      render status: 400, html: 'post not saved'
    end
  end

  def comments
    comments = (Post.find params[:id]).comments
    render status:200, json: comments
  rescue Exception => e
    render status: 404, json: {message: e}
  end

  def likes
    likes_on_post = (Post.find params[:id]).post_likes.select("user_id")
    users = User.where(id: likes_on_post).select(:user_name)
    user_list = []
    users.each do |ele|
      user_list.append(ele[:user_name])
    end
    render status:200, json: user_list
  rescue ActiveRecord::RecordNotFound => e
    render status: 404, json: {message: e}
  end

  private

  def posts_params
    params.require(:post_data).permit(:content, :image)
  end

end
