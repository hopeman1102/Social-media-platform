class ApplicationController < ActionController::API
  def encode_token(token)
    JWT.encode(
      token, 
      Rails.application.secrets.secret_key_base
    )
  end

  def decode_token
    auth_header = request.headers['Authorization']
    if auth_header
      #eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozfQ.zNubY6aofl2h7HaiXyKqiDwN2Ii_PgCnWa4pzJOv83I
      #header.payload.signature [1] is for the payload
      token = auth_header.split(" ")[1]
      begin
        JWT.decode token, Rails.application.secrets.secret_key_base, 'HS256'
      rescue JWT::DecodeError
        nil 
      end
    end
  end

  def authorized_user
    decoded_token = decode_token # {"uid": 1}
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @user = User.find user_id
      return true
    end
  end

  def authorize 
    unless authorized_user
      render json: {message: "You have to log in"}, status: :unauthorized
    end
  end

end
