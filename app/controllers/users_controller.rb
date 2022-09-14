class UsersController < ApplicationController
before_action :authorize, only: [:index]
  def show
    render json: User.find(params[:id]), status: 200
  rescue ActiveRecord::RecordNotFound
    render html: "User not exists", status: 400
  end

  def create
    user = User.new(user_params)
    if user.save
      render status: 200, html: 'User saved'
    else
      render status: 400, html:"User not saved"
    end
  end

  def index
    if @user
      render json: { user_data: @user, user_posts: @user.posts }, status: 200
    end
  end

  def log_in
    user = User.find_by(user_name: params[:user_name])
    if user.present? && user.authenticate(params[:password])
      jwt = encode_token({ "user_id": user.id, "expire": 24.hours.from_now })
      render status: 200, json: { token: jwt,
                                  username: user.user_name }
    else
      render status: 400, html: "Wrong pass or username"
    end
  end

  private

  def user_params
    params.require(:user_data).permit(:name, :user_name, :bio, :password, :password_confirmation)
  end

end
