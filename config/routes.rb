Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: [:index, :create, :show]

  resources :posts, only: [:index, :create, :show]

  resources :comments, only: [:create]

  post '/log_in', to: 'users#log_in'

  get '/my_posts', to: 'sessions#myposts'

  get '/sign_out', to: 'sessions#sign_out'

end
