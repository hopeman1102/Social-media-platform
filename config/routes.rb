Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post "/new_user", to: "users#create"

  post "/new_post", to: "posts#create"

end
