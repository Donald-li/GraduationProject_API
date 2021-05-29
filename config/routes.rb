Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :articles do
    post 'upload_img',to:'articles#upload_img',on: :collection
    get 'show_by_page_index',to:'articles#show_by_page_index',on: :collection
    get 'search/:array',to:'articles#search', on: :collection
    get 'get_comment/:uid/:aid',to:'articles#get_comment', on: :collection
  end
  resources :users do
    resources :articles
    post :login, on: :collection
    get :current_user, on: :collection
    get 'get_articles/:id/:offset/:pagesize',to:'users#get_articles', on: :collection
    # get 'search_user_group/:uname/:state/:start_time/:end_time',to:'users#search_user_group', on: :collection
    get 'changState/:id/:state',to:'users#changState', on: :collection
    get 'changeRole/:id/:role',to:'users#changeRole', on: :collection
    get 'index_page/:pagesize/:offset',to:'users#index_page',on: :collection
    get 'get_follow_user/:id/:offset/:pagesize',to:'users#get_follow_user',on: :collection
    get 'get_total_follow_user/:id',to:'users#get_total_follow_user',on: :collection
    get 'get_session_user/:id',to:'users#get_session_user',on: :collection
    get 'focues_user/:uid/:fid',to:'users#focues_user',on: :collection
    get 'isFocues/:aid/:fid',to:'users#isFocues',on: :collection
    get 'user_score_article/:uid/:aid/:score',to:'users#user_score_article',on: :collection
    get 'user_thumb_article/:uid/:aid',to:'users#user_thumb_article',on: :collection
    get 'user_collect_article/:uid/:aid',to:'users#user_collect_article',on: :collection
    get 'get_collect_page/:uid/:offset/:pagesize',to:'users#get_collect_page',on: :collection
    get 'get_collect_count/:uid',to:'users#get_collect_count',on: :collection
    get 'get_focues_count/:uid',to:'users#get_focues_count',on: :collection
    get 'isThumb/:uid/:aid',to:'users#isThumb',on: :collection
    get 'isCollect/:uid/:aid',to:'users#isCollect',on: :collection
    get 'active_user/:uid',to:'users#active_user',on: :collection
    get 'get_messages_two_user/:uid/:rid',to:'users#get_messages_two_user',on: :collection
    delete 'uncollect/:uid/:aid',to:'users#uncollect',on: :collection
    delete 'unthumb/:uid/:aid',to:'users#unthumb',on: :collection
    delete 'unfocues/:uid/:fid',to:'users#unfocues',on: :collection
    post 'uploadfile',to:'users#uploadfile',on: :collection
    post 'create_message',to:'users#create_message',on: :collection
  end

  resources :comments

  get 'main/init/:title', to: 'main#init'
  get 'main/initSections/:title', to: 'main#initSections'
end
