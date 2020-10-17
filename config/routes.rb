Rails.application.routes.draw do
  resources :webpages, :path => "web"
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#index'
end
