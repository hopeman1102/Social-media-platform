class UsersController < ApplicationController
before_action :authorize, only: [:index, :sign_out, :posts]
  def show
    render json: User.select(:user_name, :name, :bio, :id).find(params[:id]), status: 200
  rescue ActiveRecord::RecordNotFound
    render html: 'User not exists', status: 400
  end

  def create
    user = User.new(user_params)
    user.name.squish!
    user.user_name.squish!
    user.password.squish!
    user.password_confirmation.squish!
    user.bio.squish!
    if user.save!
      render status: 200, html: 'User saved'
    else
      render status: 400, html: 'User not saved'
    end
  rescue ActiveRecord::RecordInvalid => e
    render status: 422, json: {message: e}
  end

  def index
    if @user
      render json: { 
                user_data: @user, 
                user_posts: @user.posts.select(:id, :content, :image, :like_count, :comment_count) }, 
             status: 200
    end
  end

  def log_in
    user = User.find_by(user_name: params[:user_name])
    params[:password].squish!
    if user.present? && user.authenticate(params[:password])
      jwt = encode_token({ "user_id": user.id, "expire": 24.hours.from_now })
      response.add_header "token", jwt
      render status: 200, json: { username: user.user_name }
    else
      render status: 400, html: 'Wrong pass or username'
    end
  end

  def posts
    posts = (User.select(:user_name, 
                         :name, 
                         :bio, 
                         :id).find params[:id]).posts.select(:id,
                                                             :content, 
                                                             :image, 
                                                             :like_count,
                                                             :comment_count)
    render status:200, json: posts
  rescue Exception => e
    render status: 404, json: {message: e}
  end

  def sign_out
    name = @user.user_name
    @user = nil
    render status: 200, json: {message: "#{name} sign out success fully", username: name}
  end

  private

  def user_params
    params.require(:user_data).permit(:name, :user_name, :bio, :password, :password_confirmation)
  end
end


## SIGN OUT KA KARNA H