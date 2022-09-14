require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do
  before do
    User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
  end
  get 'users/:id' do
    context "200" do
      User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
      x = User.first
      let(:id) {x[:id]}
      it "Show user with valid id in the link" do
        do_request()
        expect(status).to eq(200)
      end
    end
    context "400" do
      let(:id) {1}
      it "Show user with invalid id in the link" do
        do_request()
        expect(status).to eq(400)
      end
    end
  end
  get "my_posts", :type => :controller do
    before do
      User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
      token = {user_id: User.first.id}
      Post.create(user_id: token["user_id"], content: "Content")
      header 'Authorization', "bearer #{JWT.encode(token, Rails.application.secrets.secret_key_base)}"
    end
    context "200" do 
      it "Show posts of the logged in user" do
        do_request()
        expect(status).to eq(200)
      end
    end
    context "401" do
      before do
        header 'Authorization', 'bearer'
      end
      it "My post page not available for user who have not logged in" do
        res = do_request()
        expect(status).to eq(401)
      end
    end
  end
  get "users", :type => :controller do
    before do
      User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
      token = {user_id: User.first.id}
      header 'Authorization', "bearer #{JWT.encode(token, Rails.application.secrets.secret_key_base)}"
    end
    context "200" do 
      it "Show profile of the logged in user" do
        do_request()
        expect(status).to eq(200)
      end
    end
    context "401" do 
      before do
        header 'Authorization', ""
      end
      it "Invalid profile for user not logged in" do
        do_request()
        expect(status).to eq(401)
      end
    end
    context "400" do 
      before do
        token = {user_id: 0}
        header 'Authorization', "bearer #{JWT.encode(token, Rails.application.secrets.secret_key_base)}"
      end
      it "Invalid profile for user not exists" do
        do_request()
        expect(status).to eq(400)
      end
    end
  end

  post "users" do
    before do
      User.create(user_name: "alreadyauser", password: "123456", password_confirmation: "123456")
    end
    context "200" do
      it "Create a new user" do
        params_obj = {user_data: {name: "test",user_name: "test",
          bio: "Hello everyone!! I'm test", password: "123456",password_confirmation: "123456"}}
        do_request(params_obj)
        expect(status).to eq(200)
      end
    end
    context "400" do
      it "Create a new user wrong passwords" do
        params_obj = {user_data: {name: "test",user_name: "test",
          bio: "Hello everyone!! I'm test", password: "123",password_confirmation: "123456"}}
        do_request(params_obj)
        expect(status).to eq(400)
      end
    end
    context "400" do
      it "Create a new user with existing user name" do
        params_obj = {user_data: {name: "alreadyauser",user_name: "alreadyauser",
          bio: "Hello everyone!! I'm test", password: "123456", password_confirmation: "123456"}}
        do_request(params_obj)
        expect(status).to eq(400)
      end
    end
  end

end