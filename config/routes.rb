Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :user1

  resources :users, only: [:index, :create, :show]

  resources :posts, only: [:index, :create, :show]

  resources :comments, only: [:create]

  post '/log_in', to: 'users#log_in'

  get '/sign_out', to: 'users#sign_out'

end
