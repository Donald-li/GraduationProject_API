Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :articles do
    post 'upload_img',to:'articles#upload_img',on: :collection
    get 'show_by_page_index',to:'articles#show_by_page_index',on: :collection
    get 'search/:array',to:'articles#search', on: :collection
  end
  resources :users do
    resources :articles
    post :login, on: :collection
    get :current_user, on: :collection
    get 'get_articles/:id/:offset/:pagesize',to:'users#get_articles', on: :collection
    get 'get_star_articles/:id',to:'users#get_star_articles',on: :collection
    get 'get_follow_user/:id',to:'users#get_follow_user',on: :collection
    get 'get_session_user/:id',to:'users#get_session_user',on: :collection
    get 'focues_user/:uid/:fid',to:'users#focues_user',on: :collection
    delete 'unfocues/:uid/:fid',to:'users#unfocues',on: :collection
    post 'uploadfile',to:'users#uploadfile',on: :collection
  end

  get 'main/init/:title', to: 'main#init'
end
