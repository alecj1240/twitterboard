Rails.application.routes.draw do
  root 'pages#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  get '/auth/:provider/callback', to: 'sessions#create'

  get 'jobs' => 'tweet#index'
  get 'tweet/approve'
  post 'tweet/approved' => 'tweet#approved'
  post 'tweet/denied' => 'tweet#denied'
  post 'tweet/thread_approved' => 'tweet#thread_approved'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
