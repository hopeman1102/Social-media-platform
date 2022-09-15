require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Posts' do
  before do
    User.create(user_name: "test1", password: "12345", password_confirmation: "12345")
    User.create(user_name: "test2", password: "12345", password_confirmation: "12345")
    u = User.first
    Post.create(user_id: u[:id],content: "This is the first post")
    Post.create(user_id: u[:id],content: "This is the second post")
    header 'Authorization', "bearer #{JWT.encode({user_id: u[:id]}, Rails.application.secrets.secret_key_base)}"
    # let(:raw_post) { params.to_json }
  end
  get 'posts/:id' do
    context "200" do
      let(:id) {Post.first[:id]}
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

  get "posts" do 
    context "200" do
      it "Show post of a logged in user" do
        do_request()
        expect(status).to eq(200)
      end
    end
    context "401" do
      before do
        header 'Authorization', ''
      end
      it "Show error if the user is not logged in" do
        do_request()
        expect(status).to eq(401)
      end
    end
  end

  post "posts" do
    context "200" do
      it "Create a new post" do
        params_obj = {post_data: {content: "New Post created"}}
        do_request(params_obj)
        expect(status).to eq(200)
      end
    end
    context "400" do
      before do
        header 'Authorization', "bearer #{JWT.encode({user_id: 0}, Rails.application.secrets.secret_key_base)}"
      end
      it "Create a new post with wrong token" do
        params_obj = {post_data: {content: "New Post created"}}
        do_request(params_obj)
        expect(status).to eq(400)
      end
    end
  end
end