Rails.application.routes.draw do
  devise_for :users
  resources :documents do
    resources :references, only: ["new", "create"]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root to: 'pages#home'

  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
