class PostsController < ApplicationController
  before_action :authorize, only: [:create, :index, :destroy]

  def show
    post = Post.select(:id, 
                       :content, 
                       :image, 
                       :like_count,
                       :comment_count).find(params[:id])
    render json: { post: post, 
                   comments: post.comments
                                 .order(created_at: :desc)
                                 .select(:id, :content, :user_id) }, 
           status: 200
    # order by
  rescue ActiveRecord::RecordNotFound
    render html: 'User not exists', status: 400
  end

  def index
    posts = @user.posts
                 .order(created_at: :desc)
                 .select(:id, 
                         :content, 
                         :image, 
                         :like_count,
                         :comment_count)
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
                                      .order(created_at: :desc)
                                      .select(:user_id, :content)
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

  def destroy
    post = Post.find params[:id]
    if post[:user_id] == @user.id
      post.comments.destroy_all
      post.post_likes.delete_all
      post.destroy
      render status: 400, json: {message: "Deleted successfully"}
    else
      render status: 400, json: {message: "You are not the author of the post"}
    end
  end

  private

  def posts_params
    params.require(:post_data).permit(:content, :image)
  end

end
