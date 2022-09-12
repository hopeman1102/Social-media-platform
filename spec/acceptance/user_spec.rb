require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do
  before do
    User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
  end
  get 'user/:id' do
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
  get 'post/:id' do
    context "200" do
      User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
      u = User.first
      Post.create(user_id: u[:id],content: "This is the content of post")
      x = Post.first
      let(:id) {x[:id]}
      it "Show post with valid id in the link" do
        do_request()
        expect(status).to eq(200)
      end
    end
    context "400" do
      let(:id) { 0 }
      it "Show post with invalid id in the link" do
        do_request()
        expect(status).to eq(400)
      end
    end
  end
  get "my_posts" do
    context "200" do 
      User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
      token = {user_id: User.first.id}
      headers['Authorization'] = JWT.encode token, Rails.application.secrets.secret_key_base
      it "Show posts of the logged in user" do
        # byebug
        do_request()
        expect(status).to eq(200)
      end
    end
  end

  get "profile" do
    context "200" do 
      User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
      token = {user_id: User.first.id}
      headers['Authorization'] = JWT.encode token, Rails.application.secrets.secret_key_base
      it "Show profile of the logged in user" do
        # byebug
        do_request()
        expect(status).to eq(200)
      end
    end
  end

end