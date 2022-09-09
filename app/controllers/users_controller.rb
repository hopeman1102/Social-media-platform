class UsersController < ApplicationController
  def new
  end
  
  def create
    user = User.new(user_params)
    if user.save!
      render status: 200, html:"User saved"
    else
      render status: 400, html:"User not saved"
    end
  end

  private

  def user_params
    params.require(:user_data).permit(:name, :user_name, :bio, :password, :password_confirmation)
  end

end
