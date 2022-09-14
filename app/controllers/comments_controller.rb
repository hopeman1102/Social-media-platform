class CommentsController < ApplicationController
  before_action :authorize, only: [:create]

  def create
    new_comment = Comment.new(comments_params)
    new_comment[:user_id] = @user[:id]
    if new_comment.save
      post = Post.find new_comment[:post_id]
      post[:comment_count] = post.comments.length
      post.save!
      render status: 200, json: {message: 'Comment saved successfully'}
    else
      render status: 400, json: {message: 'Not saved successfully'}
    end
  end

  private

  def comments_params
    params.require(:comment_data).permit(:post_id, :content)
  end

end
