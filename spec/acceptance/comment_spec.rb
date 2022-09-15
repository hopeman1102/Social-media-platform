require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Comments' do
  before do
    User.destroy_all
    Comment.destroy_all
    Post.destroy_all
    @post_user = User.create!(user_name: "test1", password: "12345", password_confirmation: "12345")
    @comment_user = User.create!(user_name: "test2", password: "12345", password_confirmation: "12345")
    @post = Post.create!(user_id: @post_user[:id],content: "This is the first post")
    Post.create!(user_id: @post_user[:id],content: "This is the second post")
    Comment.create!(user_id: @comment_user[:id], post_id: @post[:id], content: "This is a comment  on the first post")
    Comment.create!(user_id: @comment_user[:id], post_id: @post[:id], content: "This is second comment  on the first post")
    header 'Authorization', :token
  end
  post "comments" do
    before do
      @comment_user = User.create!(user_name: "test3", password: "12345", password_confirmation: "12345")
    end
    context "200" do
      let!(:token) {"bearer #{JWT.encode({user_id: @comment_user[:id]}, Rails.application.secrets.secret_key_base)}"}
      it "Create a new comment" do
        params_obj = {comment_data: {post_id: Post.first[:id], content: "New comment created"}}
        do_request(params_obj)
        expect(status).to eq(200)
      end
    end
    context "400" do
      let(:token) {"bearer #{JWT.encode({user_id: 0}, Rails.application.secrets.secret_key_base)}"}
      it "Create a new comment with wrong token" do
        params_obj = {comment_data: {post_id: @post[:id], content: "New comment created"}}
        do_request(params_obj)
        expect(status).to eq(400)
      end
    end
    context "400" do
      before do
        @comment_user = User.create(user_name: "test3", password: "12345", password_confirmation: "12345")
      end
      let(:token) {"bearer #{JWT.encode({user_id: @comment_user[:id]}, Rails.application.secrets.secret_key_base)}"}
      it "Create a new comment with wrong post id" do
        params_obj = {comment_data: {post_id: 0, content: "New comment created"}}
        do_request(params_obj)
        expect(status).to eq(400)
      end
    end
  end
end