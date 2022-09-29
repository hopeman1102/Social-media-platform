class UsersController < ApplicationController
  before_action :authorize, only: [:index, :sign_out, :posts, :update, :destroy, :update_password]
  def show
    render json: User.select(:user_name, :name, :bio, :id).find(params[:id]), status: 200
  rescue ActiveRecord::RecordNotFound
    render html: 'User not exists', status: 400
  end

  def send_otp 
    details = otp_params
    details[:user_name].squish!
    details[:email].squish!
    if !User.find_by(email: details[:email]) and !User.find_by(user_name: details[:user_name])
      redis = Redis.new
      otp = rand(10000...99999)
      details[:otp] = otp
      redis.setex(details[:user_name], 600, otp)
      ForgotPasswordMailer.forgot_password(details).deliver 
    else
      render json: {message: "Email/User_name already exists"}
    end
  end

  def otp_verification
    redis = Redis.new
    details = otp_params
    if redis.get(details[:user_name]).to_i == details[:otp]
      details[:user_name].squish!
      details[:email].squish!
      details[:password].strip!
      details[:password_confirmation].strip!
      user = User.new(user_name: details[:user_name],
                      email: details[:email],
                      password: details[:password], 
                      password_confirmation: details[:password_confirmation])
      if user.save!
        render status: 200, json: {message: "User Saved"}
      else
        render status: 400, hjson: {message: "User not saved"}
      end
    else
      render status: 400, json: {message: "OPT not correct"}
    end
  rescue ActiveRecord::RecordInvalid => e
    render status: 422, json: {message: e}
  end

  def create
    redis = Redis.new
    details = otp_params
    if redis.get(details[:user_name]).to_i == details[:otp]
      user = User.new(user_name: details[:user_name],
                      email: details[:email],
                      password: details[:password], 
                      password_confirmation: details[:password_confirmation])
      if user.save!
        render status: 200, json: {message: "User Saved"}
      else
        render status: 400, hjson: {message: "User not saved"}
      end
    else
      render status: 400, json: {message: "OPT not correct"}
    end
  rescue ActiveRecord::RecordInvalid => e
    render status: 422, json: {message: e}
  end

  def index
    if @user
      render json: { 
                user_data: @user, 
                user_posts: @user.posts
                                 .order(created_at: :desc)
                                 .select(:id, 
                                         :content, 
                                         :image, 
                                         :like_count, 
                                         :comment_count)}, 
             status: 200
    end
  end

  def log_in
    user = User.find_by(user_name: params[:user_name])
    params[:password].strip!
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
    posts = post_author.posts
                       .order(created_at: :desc)
                       .select(:id,
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
      user.email = params[:email] if params[:email]
      if user.save
        render status: 200, json: {message: "Changes saved"}
      end
    else
      render status: 400, json: {message: "You are not changing your details. (User id no match)"}
    end
  end

  def update_password
    password_data = update_password_params
    if password_data[:confirmation_for_password_change]
      user = User.find_by(user_name: @user.user_name)
      if user.authenticate(password_data[:current_password])
        user.password = password_data[:new_password]
        user.password_confirmation = password_data[:new_password_confirmation]
        if user.save!
          render status: 200, json: {message: "Password has been updated"}
        end
      else
        render status: 400, json: {message: "Wrong current password, or not accessing your own password"}
      end
    else
      render status: 400, json: {message: "Please give the confirmation for the password change"}
    end
  end

  private

  def otp_params
    params.require(:user_data).permit(:user_name, :email, :otp, :password, :password_confirmation)
  end

  def user_params
    params.require(:user_data).permit(:name, :user_name, :email, :bio, :password, :password_confirmation)
  end

  def update_password_params
    params.require(:password_data).permit(:current_password,
                                          :new_password, 
                                          :new_password_confirmation, 
                                          :confirmation_for_password_change)
  end

end


## SIGN OUT KA KARNA H