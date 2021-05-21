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
    # get 'get_star_articles/:id',to:'users#get_star_articles',on: :collection
    get 'get_follow_user/:id/:offset/:pagesize',to:'users#get_follow_user',on: :collection
    get 'get_session_user/:id',to:'users#get_session_user',on: :collection
    get 'focues_user/:uid/:fid',to:'users#focues_user',on: :collection
    get 'isFocues/:aid/:fid',to:'users#isFocues',on: :collection
    get 'user_score_article/:uid/:aid/:score',to:'users#user_score_article',on: :collection
    get 'user_thumb_article/:uid/:aid',to:'users#user_thumb_article',on: :collection
    get 'user_collect_article/:uid/:aid',to:'users#user_collect_article',on: :collection
    get 'get_collect_page/:uid/:offset/:pagesize',to:'users#get_collect_page',on: :collection
    get 'get_collect_count/:uid',to:'users#get_collect_count',on: :collection
    get 'get_focues_count/:uid',to:'users#get_focues_count',on: :collection
    delete 'uncollect/:uid/:aid',to:'users#uncollect',on: :collection
    delete 'unfocues/:uid/:fid',to:'users#unfocues',on: :collection
    post 'uploadfile',to:'users#uploadfile',on: :collection
  end

  get 'main/init/:title', to: 'main#init'
end
