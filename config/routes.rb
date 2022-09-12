Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post "/new_user", to: "users#create"

  post "/new_post", to: "sessions#create_new_post"

  post "/new_comment", to: "sessions#create_new_comment"

  post "/log_in", to: "users#log_in"

  get "/profile", to: "sessions#profile"

  get "/my_posts", to: "sessions#myposts"

  get "/sign_out", to: "sessions#sign_out"

  get "/post/:id", to: "posts#show"

  get "/user/:id", to: "users#show"

end
