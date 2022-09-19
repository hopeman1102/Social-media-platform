Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :user1

  resources :users, only: [:index, :create, :show, :update] do
    get :posts, on: :member
  end

  resources :posts, only: [:index, :create, :show] do
    get :comments, on: :member
    get :likes, on: :member
  end

  resources :comments, only: [:create]

  resources :post_likes, only: [:create]

  post '/log_in', to: 'users#log_in'

  get '/sign_out', to: 'users#sign_out'

end
