class PostLikesController < ApplicationController
  before_action :authorize

  def create
    post_id = post_likes_params[:post_id]
    like = PostLike.new(post_id: post_id, user_id: @user[:id])
    if like.save!
      post = Post.find post_id
      post[:like_count] += 1
      if post.save! 
        render status: 200, json: {message: "Like save"}
      end
    else
      render status: 400, json: {error: "Not saved"}
    end
  end

  private

  def post_likes_params
    params.require(:like_data).permit(:post_id)
  end

end
