class PostsController < ApplicationController
  def create 
    new_post = Post.new(posts_params)
    if new_post.save!
      render status: 200, html: "post saved"
    else
      render status: 400, html: "post not saved"
    end
  end

  private

  def posts_params
    params.require(:post_data).permit(:user_id, :content, :image)
  end

end
