class SessionsController < ApplicationController
  before_action :authorize

  def create_new_comment
    new_comment = Comment.new(comments_params)
    if new_comment[:user_id] == @user[:id]
      if new_comment.save!
        post = Post.find new_comment[:post_id]
        post[:comment_count] = post.comments.length
        post.save!
        render status: 200, html: "Comment saved successfully"
      else
        render status: 400, html: "Not saved successfully"
      end
    else
      render status: 400, html: "user_id diffrent"
    end
  end

  def create_new_post 
    new_post = Post.new(posts_params)
    if new_post[:user_id] == @user[:id]
      if new_post.save!
        render status: 200, html: "post saved"
      else
        render status: 400, html: "post not saved"
      end
    else
      render status: 400, html: "user id diffrent"
    end
  end

  def profile
    if @user
      render json: {user_data: @user, user_posts: @user.posts}, status: 200
    else
      render html: "No profile", status: 400
    end
  end

  def myposts
    render json: @user.posts, status: 200
  end

  def sign_out
    #redis      
    # eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.YFRJTQoe49iTNwHGpyX7e_qtJ1pA0FLiFZX-_8DBoIA
    # eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.uuuWPdPS7aUuiJDc56jjAW9_oAtn7QTUOB5UmoazihI
    @user = nil
    render json: "Sign out complete", status: 200
  end

  private

  def posts_params
    params.require(:post_data).permit(:user_id, :content, :image)
  end

  def comments_params
    params.require(:comment_data).permit(:user_id, :post_id, :content)
  end

end
