class CommentsController < ApplicationController
  def create
    new_comment = Comment.new(comments_params)
    if new_comment.save!
      render status: 200, html: "Comment saved successfully"
    else
      render status: 400, html: "Not saved successfully"
    end
  end

  private

  def comments_params
    params.require(:comment_data).permit(:user_id, :post_id, :content)
  end

end
