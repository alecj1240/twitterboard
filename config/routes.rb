Rails.application.routes.draw do
  get 'approval/index'
  root 'pages#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  get '/auth/:provider/callback', to: 'sessions#create'

  get 'jobs' => 'tweet#index'
  get 'my-jobs' => 'tweet#personal'
  get 'open_tweet' => 'tweet#open_tweet', :as => "open_tweet"
  get 'approval' => 'approval#index'
  post 'approval/handle' => 'approval#handle'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
