Rails.application.routes.draw do
  get 'approval/index'
  root 'pages#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  get '/auth/:provider/callback', to: 'sessions#create'

  get 'jobs' => 'tweet#index'
  get 'approval' => 'approval#index'
  post 'approval/approved' => 'approval#approved'
  post 'approval/denied' => 'approval#denied'
  post 'approval/thread_approved' => 'approval#thread_approved'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
