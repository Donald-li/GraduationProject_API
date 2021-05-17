Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :articles
  resources :users do
    resources :articles
    post :login, on: :collection
    get :current_user, on: :collection
  end

  get 'main/init/:title', to: 'main#init'
end
