class UsersController < ApplicationController
before_action :authorize, only: [:index, :sign_out, :posts, :update, :destroy]
  def show
    render json: User.select(:user_name, :name, :bio, :id).find(params[:id]), status: 200
  rescue ActiveRecord::RecordNotFound
    render html: 'User not exists', status: 400
  end

  def create
    user = User.new(user_params)
    user.name.squish!
    user.user_name.downcase!
    user.user_name.squish!
    user.password.strip!
    user.password_confirmation.strip!
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
    post_author = User.select(:user_name,
                              :id).find params[:id]
    posts = post_author.posts.select(:id,
                                    :content,
                                    :image,
                                    :like_count,
                                    :comment_count)
    render status:200, json: {user_name: post_author[:user_name], post: posts}
  rescue Exception => e
    render status: 404, json: {message: e}
  end

  def sign_out
    name = @user.user_name
    @user = nil
    render status: 200, json: {message: "#{name} sign out success fully", username: name}
  end

  def destroy
    # byebug
    if @user.id == params[:id].to_i
      user = User.find @user.id
      user.posts.destroy_all
      username = user[:user_name]
      user.destroy
      render status: 400, json: {message: "User deleted successfully", username: username}
    else
      render status: 400, json: {message: "You are not the user"}
    end
  end

  def update
    if @user.id == params[:id].to_i
      user = User.find @user.id
      user.user_name = params[:user_name] if params[:user_name]
      user.name = params[:name] if params[:name]
      user.bio = params[:bio] if params[:bio]
      if user.save
        render status: 200, json: {message: "Changes saved"}
      end
    else
      render status: 400, json: {message: "You are not changing your details. (User id no match)"}
    end
  end

  private

  def user_params
    params.require(:user_data).permit(:name, :user_name, :bio, :password, :password_confirmation)
  end
end


## SIGN OUT KA KARNA H