Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in', as: :guest_sign_in
  end

  resources :users, only:[:index, :show, :edit, :update] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end

  resources :posts do # postsの標準的な7つのRESTfulルート（index, show, new, create, edit, update, destroy）を生成
    resources :comments, only:[:create, :destroy] # postに紐づくリソースをネストして定義
    resource :favorites, only:[:create, :destroy] # 単数形のため1:1関係
    collection do # posts全体に対するアクション（個別のpostには関係しない）でconfirmアクションを追加
      get 'confirm'
    end
  end

  resources :rooms, only: [:create, :show] do
    resources :messages, only:[:create]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root :to => 'homes#top'
end
 