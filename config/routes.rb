KboApi::Application.routes.draw do

  get "batters/chart"
  match 'comments(.format)' => 'comments#create', :via => :post
  match 'comments/:id(.format)' => 'comments#show', :via => :get, :constraints => {:id => /\d+/}
  match 'get_comments(.format)' => 'comments#getComments', :via => :get
  match 'get_more_comments(.format)' => 'comments#getMoreComments', :via => :get

  match 'users(.format)' => 'users#create', :via => :post
  match 'users(.format)' => 'users#destroy', :via => :delete

  match 'users/update(.format)' => 'users#update', :via => :post
  match 'users/get_userinfo_by_nickname(.format)' => 'users#getUserInfoByNickname', :via => :get 
  match 'users/get_userinfo(.format)' => 'users#getUserInfo', :via => :get 
  match 'users/get_nickname_uniqueness(.format)' => 'users#checkUniqueness', :via => :get 
  match 'users/block(.format)' => 'users#blockUser', :via => :post  
  match 'users/unblock(.format)' => 'users#unBlockUser', :via => :post  
  match 'users/blocked_list(.format)' => 'users#getBlockedUserList', :via => :get  
  # match 'users/alert(.format)' => 'users#alertUser', :via => :post  
  match 'users/high_alert_users(.format)' => 'users#getHighAlertUsers', :via => :get
  match 'users/high_alert_usersv2(.format)' => 'users#getHighAlertUsersV2', :via => :get
  match 'users/get_all_users(.format)' => 'users#getUserList', :via => :get
  match 'users/alert(.format)' => 'users#alertUserV2', :via => :post  
  match 'users/update_nickname(.format)' => 'users#updateNickname', :via => :post  

  match 'update(.json)' => 'updates#create', :via => :post
  match 'update/get_last_update(.json)' => 'updates#getLastUpdate', :via => :get

  match 'articles(.format)' => 'articles#create', :via => :post
  match 'articles/get_articles(.format)' => 'articles#getArticles', :via => :get
  match 'articles/get_articles_by_like(.format)' => 'articles#getArticlesByLike', :via => :get

  match 'articles/alert(.format)' => 'articles#alert', :via => :post
  match 'articles/like(.format)' => 'articles#like', :via => :post
  match 'articles/vote(.format)' => 'articles#vote', :via => :post
  match 'articles/:id(.format)' => 'articles#deleteArticle', :via => :delete, :constraints => {:id => /\d+/}

  match 'boards(.format)' => 'boards#create', :via => :post
  match 'boards/update(.format)' => 'boards#update', :via => :post
  
  match 'boards/:id(.format)' => 'boards#show', :via => :get, :constraints => {:id => /\d+/}
  match 'boards/vote(.format)' => 'boards#vote', :via => :post
  match 'boards/get_boards(.format)' => 'boards#getBoards', :via => :get
  match 'boards/get_boards_by_like(.format)' => 'boards#getBoardsByLike', :via => :get  
  match 'boards/get_all_board(.format)' => 'boards#getAllBoards', :via => :get
  match 'boards/:id(.format)' => 'boards#deleteBoard', :via => :delete, :constraints => {:id => /\d+/}
  match 'boards/delete_board_by_imei(.format)' => 'boards#deleteBoardByImei', :via => :delete
  match 'boards/dev/:id(.format)' => 'boards#manageByDeveloper', :via => :delete, :constraints => {:id => /\d+/}

  match 'boards/add_reply(.format)' => 'boards#add_reply', :via => :post
  match 'boards/alert(.format)' => 'boards#alert', :via => :post
  #match 'articles/delete_all(.json)' => 'articles#deleteAllArticles', :vis => :post

  #data api
  match 'ranks/chart(.format)' => 'ranks#chart', :via => :get
  match 'batters/chart(.format)' => 'batters#chart', :via => :get
  match 'schedules/chart(.format)' => 'schedules#chart', :via => :get
  match 'schedules/chart_by_date(.format)' => 'schedules#chart_by_date', :via => :get

  match 'scorelist/chart(.format)' => 'score_lists#chart', :via => :get
  match 'reports/chart(.format)' => 'reports#list', :via => :get
  match 'total_rank/chart(.format)' => 'total_ranks#chart', :via => :get
  match 'total_hitter_rank/chart(.format)' => 'total_hitter_ranks#chart', :via => :get
  match 'teaminfos/chart(.format)' => 'team_infos#chart', :via => :get
end
